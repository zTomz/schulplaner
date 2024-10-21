import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/shared/exceptions/ai_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

abstract class AiService {
  static const String _aiModelName = 'gemini-1.5-pro';

  /// Get the generative model used by the service with the correct configuration and a system instruction which holds the needed information.
  static GenerativeModel _getGenrativeModel({
    required WeeklyScheduleData weeklyScheduleData,
    required EventData events,
    required HobbiesData hobbies,
  }) {
    final systemInstructionText =
        """You are an AI assistant for pupils in a school planner app. The user can manage their timetable and hobbies in the app.
They can also create appointments such as homework, assignments or just reminders.
- The current date and time is: ${DateTime.now()}
- Events that the user has already created: ${events.getFormattedMap(weeklyScheduleData: weeklyScheduleData)}
- The user's timetable: ${weeklyScheduleData.formattedMap}
- The user's hobbies: ${hobbies.formattedMap}""";

    return FirebaseVertexAI.instance.generativeModel(
      model: _aiModelName,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
      ),
      systemInstruction: Content.system(systemInstructionText),
    );
  }

  static Future<Either<AiException, ProcessingDate>>
      generateHomeworkProcessingDateWithAi({
    required Difficulty difficulty,
    required WeeklyScheduleData weeklyScheduleData,
    required EventData events,
    required HobbiesData hobbies,
    required Subject subject,
    required DateTime deadline,
  }) async {
    final model = _getGenrativeModel(
      weeklyScheduleData: weeklyScheduleData,
      events: events,
      hobbies: hobbies,
    );
    final prompt = [
      Content.text(
          """Your task is to generate a date when a homework assignment should be completed. There is a deadline, namely the following date: $deadline.
The homework must be completed by this date. The homework is to be completed in the subject ${subject.getCompleteMap(weeklyScheduleData.teachers)} and the user thinks that 
it will be ${difficulty.englishName}.


The answer should be in JSON like the following:
{
  'date': (a ISO 8601 string),
  'timeSpan': {
    'from': {
      hour: (int),
      minute: (int),
    },
    'to': {
      hour: (int),
      minute: (int),
    },
  },
}

 
A time span has a start time and an end time. The start time is the time when the homework is to be completed and the end time is the time when the homework is to be completed,
when the homework is to be completed. The start time must be before the end time.

When generating, please ensure that the processing date does not coincide with another date or other events. And if possible, the user should not
too many tasks on the same day and be able to take a break in between. An easy task takes approx. 45 minutes to complete, a medium task approx. 90 minutes and
a difficult one about 120 minutes.
"""),
    ];

    GenerateContentResponse response;
    try {
      response = await model.generateContent(prompt);
    } catch (e) {
      logger.e("Error generating proccesing date with ai: $e");

      return Left(
        AiGeneratingException(
          message: "Leider ist ein Fehler beim generieren aufgetreten.",
        ),
      );
    }

    logger.i("Generated ProcessingDate: ${response.text}");

    if (response.text != null) {
      try {
        final generatedProcessingDate = ProcessingDate.fromMap(
          jsonDecode(response.text.toString()) as Map<String, dynamic>,
        );
        return Right(
          // Used to set the time of the date to the start of the time span
          generatedProcessingDate.copyWith(
            date: generatedProcessingDate.date.copyWith(
              hour: generatedProcessingDate.timeSpan.from.hour,
              minute: generatedProcessingDate.timeSpan.from.minute,
            ),
          ),
        );
      } catch (e) {
        logger.e("Error while parsing the processing date generated by ai: $e");
        return Left(
          AiParsingException(
            message: "Leider ist ein Fehler beim generieren aufgetreten.",
          ),
        );
      }
    } else {
      logger.e("Cannot generate a processing date. Response is null.");
      return Left(
        AiGeneratingException(
          message: "Leider ist ein Fehler beim generieren aufgetreten.",
        ),
      );
    }
  }
}
