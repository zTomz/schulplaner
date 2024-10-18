import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/dialogs/events/event_date_dialog.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/widgets/time_picker_modal_bottom_sheet.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/config/constants/strings.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/get_value_or_null.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
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
    final subjects = weeklyScheduleData.right?.subjects ?? [];
    final teachers = weeklyScheduleData.right?.teachers ?? [];
    final lessons = weeklyScheduleData.right?.lessons ?? [];

    final nameController = useTextEditingController(
      text: homeworkEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: homeworkEvent?.description,
    );
    final subject = useState<Subject?>(
      firstWhereOrNull(
        weeklyScheduleData.right?.subjects ?? [],
        (s) => s.uuid == homeworkEvent?.subjectUuid,
      ),
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
      fatalError: weeklyScheduleData.isLeft()
          ? Text(weeklyScheduleData.left.toString()) // TODO: Better errors
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
                      onSubjectCreated: (subject) async {
                        await ref
                            .read(weeklyScheduleProvider.notifier)
                            .addSubject(subject: subject);
                      },
                      onSubjectEdited: (subject) async {
                        await ref
                            .read(weeklyScheduleProvider.notifier)
                            .editSubject(subject: subject);
                      },
                      onTeacherCreated: (teacher) async {
                        await ref
                            .read(weeklyScheduleProvider.notifier)
                            .addTeacher(teacher: teacher);
                      },
                      onTeacherEdited: (teacher) async {
                        await ref
                            .read(weeklyScheduleProvider.notifier)
                            .editTeacher(teacher: teacher);
                      },
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
                          weeklyScheduleData.isRight()
                      ? () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) =>
                                GenerateProcessingDateWithAiDialog(
                              weeklyScheduleData: weeklyScheduleData.right!,
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
                Navigator.of(context).pop();
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
  final WeeklyScheduleData weeklyScheduleData;
  final Subject subject;
  final DateTime deadline;

  const GenerateProcessingDateWithAiDialog({
    super.key,
    required this.weeklyScheduleData,
    required this.subject,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventData = ref.watch(eventsProvider);
    final hobbiesData = ref.watch(hobbiesProvider);

    final difficulty = useState<Difficulty>(Difficulty.easy);

    final errorMessage = useState<String?>(null);
    final loading = useState<bool>(false);

    return CustomDialog(
      icon: const Icon(LucideIcons.sparkles),
      title: const Text("Datum und Zeitspanne generieren"),
      loading:
          eventData.right == null || hobbiesData.right == null || loading.value,
      fatalError: eventData.isLeft() || hobbiesData.isLeft()
          ? Text(
              eventData.left?.toString() ??
                  hobbiesData.left?.toString() ??
                  "Ein unbekannter Fehler ist aufgetreten",
            )
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

            // Create a map containing a list of weekdays, containing a list of time spans, containing a list of lessons for the timespan and weekday
            Map<String, dynamic> weeklySchedule = {
              'weekdays': Weekday.mondayToFriday
                  .map(
                    (day) => {
                      'day': day.name,
                      'time_spans': weeklyScheduleData.timeSpans.map(
                        (timeSpan) => {
                          'time_span': timeSpan.toMap(),
                          'lessons': weeklyScheduleData.lessons
                              .where((lesson) =>
                                  lesson.weekday == day &&
                                  lesson.timeSpan == timeSpan)
                              .map(
                                (lesson) => lesson.getCompleteMap(
                                  weeklyScheduleData.subjects,
                                  weeklyScheduleData.teachers,
                                ),
                              )
                              .toList(),
                        },
                      ),
                    },
                  )
                  .toList(),
            };

            final sortedEvents =
                eventData.right?.sortedEvents ?? ([], [], [], []);

            // Create a map, containing the already created events in a good way
            Map<String, dynamic> events = {
              "homework": sortedEvents.$1.map(
                (event) => event.getCompleteMap(
                  weeklyScheduleData.subjects,
                  weeklyScheduleData.teachers,
                ),
              ),
              "tests": sortedEvents.$2.map(
                (event) => event.getCompleteMap(
                  weeklyScheduleData.subjects,
                  weeklyScheduleData.teachers,
                ),
              ),
              "reminders": sortedEvents.$3.map(
                (event) => event.toMap(),
              ),
              "repeating_events": sortedEvents.$4.map(
                (event) => event.toMap(),
              ),
            };

            // Create a map containing the user's hobbies
            Map<String, dynamic> hobbies = {
              "hobbies": hobbiesData.right ??
                  []
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
                """The homework is in the subject: ${subject.getCompleteMap(weeklyScheduleData.teachers)}.
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
