import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/weekly_schedule.dart';

@RoutePage()
class WeeklySchedulePage extends HookConsumerWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.a);

    return weeklyScheduleData.fold(
      (failure) => const DataErrorWidget(),
      (data) {
        List<Lesson> lessons = data.lessons;
        Set<TimeSpan> timeSpans = data.timeSpans;
        final List<Teacher> teachers = data.teachers;
        final List<Subject> subjects = data.subjects;

        return Scaffold(
          appBar: CustomAppBar(
            title: Text(
              "Stundenplan",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<TimeSpan>(
                    context: context,
                    builder: (context) => const EditTimeSpanDialog(),
                  );

                  if (result != null) {
                    await ref
                        .read(weeklyScheduleProvider.notifier)
                        .addTimeSpan(timeSpan: result);
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
                        final result = await _showEditLessonDialog<Lesson>(
                          context,
                          ref,
                          selectedSchoolTimeCell: selectedSchoolTimeCell.value!,
                          weeklyScheduleData: data,
                        );

                        if (result != null) {
                          await ref
                              .read(weeklyScheduleProvider.notifier)
                              .addLesson(
                                lesson: result,
                              );
                        }
                      },
                icon: const Icon(
                  LucideIcons.circle_plus,
                  size: 20,
                ),
                label: const Text("Schulstunde hinzufügen"),
              ),
              const SizedBox(width: Spacing.medium),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: WeeklySchedule(
              onLessonEdit: (lesson) async {
                final result = await _showEditLessonDialog<Lesson>(
                  context,
                  ref,
                  lesson: lesson,
                  selectedSchoolTimeCell: selectedSchoolTimeCell.value,
                  weeklyScheduleData: data,
                );

                if (result != null) {
                  await ref.read(weeklyScheduleProvider.notifier).editLesson(
                        lesson: result,
                      );
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
                  await ref
                      .read(weeklyScheduleProvider.notifier)
                      .deleteTimeSpan(timeSpan: timeSpanToDelete);
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
              data: WeeklyScheduleData(
                timeSpans: timeSpans,
                lessons: lessons,
                teachers: teachers,
                subjects: subjects,
              ),
              week: week.value,
            ),
          ),
        );
      },
    );
  }
}

Future<T?> _showEditLessonDialog<T>(
  BuildContext context,
  WidgetRef ref, {
  Lesson? lesson,
  SchoolTimeCell? selectedSchoolTimeCell,
  required WeeklyScheduleData weeklyScheduleData,
}) async {
  return await showDialog<T?>(
    context: context,
    builder: (context) => EditLessonDialog(
      lesson: lesson,
      subjects: weeklyScheduleData.subjects,
      teachers: weeklyScheduleData.teachers,
      schoolTimeCell: selectedSchoolTimeCell,
      onLessonDeleted: (lesson) async {
        await ref
            .read(weeklyScheduleProvider.notifier)
            .deleteLesson(lesson: lesson);
      },
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
}
