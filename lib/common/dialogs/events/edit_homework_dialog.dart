import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/functions/handle_state_change_database.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/data_state_widgets.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:uuid/uuid.dart';

class EditHomeworkDialog extends HookConsumerWidget {
  final HomeworkEvent? homeworkEvent;

  const EditHomeworkDialog({
    super.key,
    this.homeworkEvent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final subject = useState<Subject?>(
      weeklyScheduleData.hasValue
          ? firstWhereOrNull(
              weeklyScheduleData.value!.$4,
              (s) => s.uuid == homeworkEvent?.subjectUuid,
            )
          : null,
    );
    final date = useState<DateTime?>(homeworkEvent?.date);
    final color = useState<Color>(subject.value?.color ?? Colors.blue);
    final nameController = useTextEditingController(
      text: homeworkEvent?.name ?? "Hausaufgabe ",
    );
    final descriptionController = useTextEditingController(
      text: homeworkEvent?.description,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return weeklyScheduleData.when(
      data: (value) {
        final List<Lesson> lessons = value.$1;
        final List<Teacher> teachers = value.$3;
        final List<Subject> subjects = value.$4;

        return CustomDialog.expanded(
          icon: const Icon(LucideIcons.book_open_text),
          title: Text(
            "Hausaufgaben ${homeworkEvent == null ? "erstellen" : "bearbeiten"}",
          ),
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

                        if (color.value == Colors.blue) {
                          color.value = result.color;
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

                      // final result = await showDialog<EventDate>(
                      //   context: context,
                      //   builder: (context) => const EventDateDialog(),
                      // );

                      // if (result != null) {
                      //   eventDate.value = result;
                      // }
                    },
                    child: const Text("Datum & Uhrzeit"),
                  ),
                ),
                const SizedBox(height: Spacing.small),
                CustomTextField(
                  controller: descriptionController,
                  labelText: "Beschreibung",
                  maxLines: 3,
                  minLines: 3,
                )
              ],
            ),
          ),
          actions: [
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
      },
      error: (_, __) => const DataErrorWidget(),
      loading: () => const DataLoadingWidget(),
    );
  }
}

class TimePickerModalBottomSheet extends StatelessWidget {
  final Subject? subject;
  final List<Lesson> lessons;

  const TimePickerModalBottomSheet({
    super.key,
    required this.subject,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.medium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(Spacing.medium),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          _buildCustomButton(
            label: "Nächste Stunde",
            icon: const Icon(LucideIcons.calendar_plus),
            onPressed: subject == null
                ? null
                : () {
                    // Get the next lesson of the subject
                    final sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the sorted lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Sort the lessons by weekday
                    sortedLessons.sort(
                      (a, b) => a.weekday.index < b.weekday.index ? -1 : 1,
                    );

                    final nextLesson = firstWhereOrNull<Lesson>(
                      sortedLessons,
                      (lesson) => lesson.subjectUuid == subject!.uuid,
                    );

                    // Get the date of the next lesson, if it is null, return null
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get the difference between the current weekday and the next lesson weekday
                    final difference =
                        currentWeekday.getDifference(nextLesson.weekday);

                    Navigator.of(context).pop(
                      DateTime.now().add(
                        Duration(days: difference),
                      ),
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            label: "Übernächste Stunde",
            icon: const Icon(LucideIcons.calendar_plus_2),
            onPressed: subject == null
                ? null
                : () {
                    // Get the next lesson of the subject
                    final sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the sorted lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    sortedLessons.sort(
                      (a, b) => a.weekday.index < b.weekday.index ? -1 : 1,
                    );

                    // Get the next but one lesson
                    Lesson? nextLesson;
                    bool onlyOneLessonOfSubjectInWeek = false;
                    if (sortedLessons.sublist(1).isEmpty) {
                      onlyOneLessonOfSubjectInWeek = true;

                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons,
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    } else {
                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons.sublist(1),
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    }

                    // Get the date of the next lesson, if it is null, return null
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get the difference between the current weekday and the next lesson weekday
                    int difference =
                        currentWeekday.getDifference(nextLesson.weekday);

                    // Add 7, because we want the next but one lesson. So we need to add one week, if there is only one lesson of the provided subject in the week
                    if (onlyOneLessonOfSubjectInWeek) {
                      difference += 7;
                    }

                    Navigator.of(context).pop(
                      DateTime.now().add(
                        Duration(days: difference),
                      ),
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            label: "Datum auswählen",
            icon: const Icon(LucideIcons.calendar_days),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2008),
                lastDate: DateTime(2055),
              );

              if (date == null && context.mounted) {
                Navigator.of(context).pop(null);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(date);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required Widget icon,
    required void Function()? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
        padding: const EdgeInsets.all(
          Spacing.medium,
        ),
      ),
      icon: icon,
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(label),
      ),
    );
  }
}
