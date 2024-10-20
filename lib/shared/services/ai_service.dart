import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/shared/exceptions/ai_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

abstract class AiService {
  static const String aiModelName = 'gemini-1.5-flash';

  static Future<Either<AiException, ProcessingDate>>
      generateHomeworkProcessingDateWithAi({
    required Difficulty difficulty,
    required WeeklyScheduleData weeklyScheduleData,
    required EventData events,
    required HobbiesData hobbies,
    required Subject subject,
    required DateTime deadline,
  }) async {
    final systemInstructionText =
        """You are an AI assistant in a school planner app. The user can add events such as homework, assignments and reminders. He also has a timetable and his hobbies stored in the app. Here is some basic information you need.
- The current date is: ${DateTime.now()}
- Events that the user has already created: ${events.getFormattedMap(weeklyScheduleData: weeklyScheduleData)}
- The user's timetable: ${weeklyScheduleData.formattedMap}
- The user's hobbies: ${hobbies.formattedMap}""";
    final model = FirebaseVertexAI.instance.generativeModel(
      model: aiModelName,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
      ),
      systemInstruction: Content.system(
        systemInstructionText,
      ),
    );
    final prompt = [
      Content.text(
        """The homework is in the subject: ${subject.getCompleteMap(weeklyScheduleData.teachers)}.
The deadline is: $deadline.
The user thinks, the task will be: ${difficulty.englishName}.
When do you think, the user should do the homework and how long do you think the user will need to do it? When generating the homework, please make sure that it does not interfere with lesson time or other events that have already been created. The user should also have time to relax and not have to work without a break.
A simple task will take around 45 minutes, a medium task will take around 1 and a half hour and a long task will take around 2 hours.
The answer should be in JSON like this: {
      'date': (a Iso8601 String),
      'duration': {
        'days': (int),
        'hours': int,
        'minutes': (int),
        'seconds': (int),
        'milliseconds': (int),
        'microseconds': (int),
    }
}""",
      ),
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
        return Right(
          ProcessingDate.fromMap(
            jsonDecode(response.text.toString()) as Map<String, dynamic>,
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
