import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/dialogs/events/event_date_dialog.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/provider/events_provider.dart';
import 'package:schulplaner/common/provider/hobbies_provider.dart';
import 'package:schulplaner/common/widgets/time_picker_modal_bottom_sheet.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/config/constants/strings.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/functions/handle_state_change_database.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/features/overview/widgets/generate_with_ai_button.dart';
import 'package:uuid/uuid.dart';

class EditHomeworkDialog extends HookConsumerWidget {
  final HomeworkEvent? homeworkEvent;
  final void Function()? onHomeworkDeleted;

  const EditHomeworkDialog({
    super.key,
    this.homeworkEvent,
    this.onHomeworkDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final weeklyScheduleTuple = weeklyScheduleData.valueOrNull;
    final lessons = weeklyScheduleTuple?.$1 ?? [];
    final teachers = weeklyScheduleTuple?.$3 ?? [];
    final subjects = weeklyScheduleTuple?.$4 ?? [];

    final nameController = useTextEditingController(
      text: homeworkEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: homeworkEvent?.description,
    );
    final subject = useState<Subject?>(
      weeklyScheduleData.hasValue
          ? firstWhereOrNull(
              weeklyScheduleData.value!.$4,
              (s) => s.uuid == homeworkEvent?.subjectUuid,
            )
          : null,
    );
    final date = useState<DateTime?>(homeworkEvent?.date);
    final processingDate = useState<ProcessingDate?>(
      homeworkEvent?.processingDate,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text(
        "Hausaufgaben ${homeworkEvent == null ? "hinzufügen" : "bearbeiten"}",
      ),
      icon: const Icon(LucideIcons.book_open_text),
      loading: weeklyScheduleData.isLoading,
      fatalError: weeklyScheduleData.hasError
          ? Text(weeklyScheduleData.error.toString())
          : null,
      content: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              validate: true,
              labelText: "Name",
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Fach ist erforderlich.",
              value: subject.value,
              child: CustomButton.selection(
                selection: subject.value?.name,
                onPressed: () async {
                  final result = await showDialog<Subject>(
                    context: context,
                    builder: (context) => SubjectDialog(
                      subjects: subjects,
                      teachers: teachers,
                      onSubjectChanged: (subject) => onSubjectChanged(
                        context,
                        subject,
                        subjects,
                      ),
                      onTeacherChanged: (teacher) => onTeacherChanged(
                        context,
                        teacher,
                        teachers,
                      ),
                    ),
                  );

                  if (result != null) {
                    subject.value = result;

                    if (nameController.text.trim() == "Hausaufgabe" ||
                        nameController.text.trim().isEmpty) {
                      nameController.text =
                          "Hausaufgabe ${subject.value?.name}";
                    }
                  }
                },
                child: const Text("Fach"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Datum ist erforderlich.",
              value: date.value,
              child: CustomButton.selection(
                selection: date.value?.formattedDate,
                onPressed: () async {
                  final result = await showModalBottomSheet<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return TimePickerModalBottomSheet(
                        subject: subject.value,
                        lessons: lessons,
                      );
                    },
                  );

                  if (result != null) {
                    date.value = result;
                  }
                },
                child: const Text("Datum"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            Row(
              children: [
                Expanded(
                  child: RequiredField(
                    errorText: "Ein Bearbeitungsdatum ist erforderlich.",
                    value: processingDate.value,
                    child: CustomButton.selection(
                      selection: processingDate.value?.formattedDate,
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => const ProcessingDateDialog(),
                        );

                        if (result != null) {
                          processingDate.value = result;
                        }
                      },
                      child: const Text("Bearbeitungsdatum"),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.small),
                IconButton(
                  onPressed: subject.value != null &&
                          date.value != null &&
                          weeklyScheduleTuple != null
                      ? () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) =>
                                GenerateProcessingDateWithAiDialog(
                              weeklyScheduleTuple: weeklyScheduleTuple,
                              subject: subject.value!,
                              deadline: date.value!,
                            ),
                          );

                          if (result != null) {
                            processingDate.value = result;
                          }
                        }
                      : null,
                  tooltip: "Mit KI generieren",
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(LucideIcons.sparkles),
                ),
              ],
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: descriptionController,
              labelText: "Beschreibung",
              maxLines: 3,
              minLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        if (homeworkEvent != null && onHomeworkDeleted != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Hausaufgabe löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Hausaufgabe löschen möchten?",
                ),
              );

              if (result != null && context.mounted) {
                onHomeworkDeleted?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.trash_2),
            label: const Text("Hausaufgabe löschen"),
          ),
          const Spacer(),
        ],
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            final event = HomeworkEvent(
              name: nameController.text.trim(),
              subjectUuid: subject.value!.uuid,
              description: descriptionController.text.getStringOrNull(),
              date: date.value!,
              processingDate: processingDate.value!,
              isDone: homeworkEvent?.isDone ?? false,
              uuid: homeworkEvent?.uuid ?? const Uuid().v4(),
            );

            Navigator.pop(
              context,
              event,
            );
          },
          child: Text(homeworkEvent == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}

class GenerateProcessingDateWithAiDialog extends HookConsumerWidget {
  final (
    List<Lesson>,
    Set<TimeSpan>,
    List<Teacher>,
    List<Subject>
  ) weeklyScheduleTuple;
  final Subject subject;
  final DateTime deadline;

  const GenerateProcessingDateWithAiDialog({
    super.key,
    required this.weeklyScheduleTuple,
    required this.subject,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventData = ref.watch(eventsProvider);
    final eventsTuple = eventData.valueOrNull;

    final hobbiesData = ref.watch(hobbiesProvider);
    final hobbiesList = hobbiesData.valueOrNull;

    final difficulty = useState<Difficulty>(Difficulty.easy);

    final errorMessage = useState<String?>(null);
    final loading = useState<bool>(false);

    return CustomDialog(
      icon: const Icon(LucideIcons.sparkles),
      title: const Text("Datum und Zeitspanne generieren"),
      loading: !eventData.hasValue || !hobbiesData.hasValue || loading.value,
      fatalError: eventData.hasError || hobbiesData.hasError
          ? Text((eventData.error ?? hobbiesData.error!).toString())
          : null,
      error: errorMessage.value != null ? Text(errorMessage.value ?? "") : null,
      content: buildBodyPart(
        title: const Text("Schwierigkeit"),
        child: SegmentedButton<Difficulty>(
          segments: Difficulty.values
              .map(
                (d) => ButtonSegment(
                  value: d,
                  label: Text(d.name),
                ),
              )
              .toList(),
          selected: {difficulty.value},
          selectedIcon: const SizedBox.shrink(),
          onSelectionChanged: (d) {
            difficulty.value = d.first;
          },
        ),
        padding: const EdgeInsets.only(bottom: Spacing.small),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        GenerateWithAiButton(
          onPressed: () async {
            errorMessage.value = null;
            loading.value = true;

            final lessons = weeklyScheduleTuple.$1;
            final timeSpans = weeklyScheduleTuple.$2;
            final teachers = weeklyScheduleTuple.$3;
            final subjects = weeklyScheduleTuple.$4;

            // Create a map containing a list of weekdays, containing a list of time spans, containing a list of lessons for the timespan and weekday
            Map<String, dynamic> weeklySchedule = {
              'weekdays': Weekday.mondayToFriday
                  .map(
                    (day) => {
                      'day': day.name,
                      'time_spans': timeSpans.map(
                        (timeSpan) => {
                          'time_span': timeSpan.toMap(),
                          'lessons': lessons
                              .where((lesson) =>
                                  lesson.weekday == day &&
                                  lesson.timeSpan == timeSpan)
                              .map(
                                (lesson) => lesson.getCompleteMap(
                                  subjects,
                                  teachers,
                                ),
                              )
                              .toList(),
                        },
                      ),
                    },
                  )
                  .toList(),
            };

            // Create a map, containing the already created events in a good way
            Map<String, dynamic> events = {
              "homework": eventsTuple!.$1.map(
                (event) => event.getCompleteMap(
                  subjects,
                  teachers,
                ),
              ),
              "tests": eventsTuple.$2.map(
                (event) => event.getCompleteMap(
                  subjects,
                  teachers,
                ),
              ),
              "reminders": eventsTuple.$3.map(
                (event) => event.toMap(),
              ),
              "repeating_events": eventsTuple.$4.map(
                (event) => event.toMap(),
              ),
            };

            // Create a map containing the user's hobbies
            Map<String, dynamic> hobbies = {
              "hobbies": hobbiesList!
                  .map(
                    (hobby) => hobby.toMap(),
                  )
                  .toList(),
            };

            final systemInstructionText =
                """You are an AI assistant in a school planner app. The user can add events such as homework, assignments and reminders. He also has a timetable and his hobbies stored in the app. Here is some basic information you need.
- The current date is: ${DateTime.now()}
- Events that the user has already created: $events
- The user's timetable: $weeklySchedule
- The user's hobbies: $hobbies""";

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
                """The homework is in the subject: ${subject.getCompleteMap(teachers)}.
The deadline is: $deadline.
The user thinks, the task will be: ${difficulty.value.englishName}.
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

            final response = await model.generateContent(prompt);

            logger.i("Generated ProcessingDate: ${response.text}");

            if (response.text != null) {
              ProcessingDate? processingDate;

              try {
                processingDate = ProcessingDate.fromMap(
                  jsonDecode(response.text.toString()) as Map<String, dynamic>,
                );
              } catch (e) {
                logger.e(
                    "Error while parsing the processing date generated by ai: $e");
                errorMessage.value =
                    "Leider ist beim generieren ein Fehler aufgetreten.";
              }

              if (processingDate != null && context.mounted) {
                loading.value = false;
                Navigator.of(context).pop(
                  processingDate,
                );
                return;
              }
            } else {
              errorMessage.value =
                  "Leider ist beim generieren ein Fehler aufgetreten.";
              loading.value = false;
              return;
            }
          },
          icon: const Icon(LucideIcons.sparkle),
          child: const Text("Generieren"),
        ),
      ],
    );
  }
}
