import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/common/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/weekly_schedule.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';

class CreateWeeklySchedulePage extends HookWidget {
  const CreateWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.a);
    final timeSpans = useState<Set<TimeSpan>>({
      const TimeSpan(
        from: TimeOfDay(hour: 7, minute: 30),
        to: TimeOfDay(hour: 9, minute: 0),
      ),
    });
    final lessons = useState<List<Lesson>>([]);

    return GradientScaffold(
      appBar: CustomAppBar(
        title: Text(
          "Stundenplan erstellen",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<TimeSpan>(
                    context: context,
                    builder: (context) => const EditTimeSpanDialog(),
                  );

                  if (result != null) {
                    timeSpans.value = {...timeSpans.value, result};
                  }
                },
                icon: const Icon(
                  LucideIcons.timer,
                  size: 20,
                ),
                label: const Text("Schulzeit hinzufügen"),
              ),
              const SizedBox(width: Spacing.medium),
              ElevatedButton.icon(
                onPressed: selectedSchoolTimeCell.value == null
                    ? null
                    : () async {
                        final result = await showDialog<Lesson>(
                          context: context,
                          builder: (context) => EditLessonDialog(
                            schoolTimeCell: selectedSchoolTimeCell.value!,
                            onLessonDeleted: null,
                            subjects: const [], // TODO: Save the subjects somewhere
                            teachers: const [], // TODO: Save the teachers somewhere
                            onSubjectChanged:
                                (subject) {}, // TODO: Implement on subject created
                            onTeacherChanged:
                                (teacher) {}, // TODO: Implement on teacher created
                          ),
                        );

                        if (result != null) {
                          lessons.value = [...lessons.value, result];
                        }
                      },
                icon: const Icon(
                  LucideIcons.circle_plus,
                  size: 20,
                ),
                label: const Text("Schulstunde hinzufügen"),
              ),
            ],
          ),
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.pushRoute(ConfigureHobbyRoute(
            weeklyScheduleData: WeeklyScheduleData(
              timeSpans: timeSpans.value,
              lessons: lessons.value,
            ),
          ));
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: WeeklySchedule(
          onLessonEdit: (lesson) async {
            final result = await showDialog<Lesson>(
              context: context,
              builder: (context) => EditLessonDialog(
                schoolTimeCell: selectedSchoolTimeCell.value,
                lesson: lesson,
                subjects: const [], // TODO: Save the subjects somewhere
                teachers: const [], // TODO: Save the teachers somewhere
                onLessonDeleted: (lesson) async {
                  List<Lesson> oldLessons = List.from(lessons.value);
                  oldLessons.removeWhere((oldLesson) => oldLesson == lesson);
                  lessons.value = [...oldLessons];

                  await closeAllDialogs(context);

                  if (context.mounted) {
                    SnackBarService.show(
                      context: context,
                      content: Text(
                        "Die Schulstunde ${lesson.subject.name} wurde gelöscht.",
                      ),
                      type: CustomSnackbarType.info,
                    );
                  }
                },
                onSubjectChanged: (subject) {
                  // TODO: Implement on subject created
                },
                onTeacherChanged: (teacher) {
                  // TODO: Implement on teacher created
                },
              ),
            );

            if (result != null) {
              List<Lesson> oldLessons = List.from(lessons.value);
              oldLessons.removeWhere((lesson) => lesson.uuid == result.uuid);
              lessons.value = [...oldLessons, result];
            }
          },
          onWeekTapped: () {
            week.value = week.value.next();
          },
          onDeleteTimeSpan: (timeSpanToDelete) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => CustomDialog.confirmation(
                title: "Schulzeit löschen",
                description:
                    "Soll die Schulzeit ${timeSpanToDelete.from.format(context)} - ${timeSpanToDelete.to.format(context)} wirklich gelöscht werden?",
              ),
            );

            // If true, delete the time span
            if (result == true) {
              // Delete the time span from the time spans
              timeSpans.value = timeSpans.value
                  .where((timeSpan) => timeSpan != timeSpanToDelete)
                  .toSet();

              // Delete all lessons for the time span
              lessons.value.removeWhere(
                (lesson) => lesson.timeSpan == timeSpanToDelete,
              );
            }
          },
          onSchoolTimeCellSelected: (schoolTimeCell) {
            // Select the cell. If the cell is already selected, unselect it
            selectedSchoolTimeCell.value =
                schoolTimeCell == selectedSchoolTimeCell.value
                    ? null
                    : schoolTimeCell;
          },
          selectedSchoolTimeCell: selectedSchoolTimeCell.value,
          timeSpans: timeSpans.value,
          lessons: lessons.value,
          week: week.value,
        ),
      ),
    );
  }
}
