import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/week_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/weekly_schedule_floating_action_button.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/weekly_schedule.dart';

@RoutePage()
class WeeklySchedulePage extends HookConsumerWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final week = ref.watch(weekProvider);

    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);

    return weeklyScheduleData.fold(
      (failure) => const DataErrorWidget(),
      (data) {
        List<Lesson> lessons = data.lessons;
        Set<TimeSpan> timeSpans = data.timeSpans;
        final List<Teacher> teachers = data.teachers;
        final List<Subject> subjects = data.subjects;

        return Scaffold(
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: WeeklyScheduleFloatingActionButton(
            selectedSchoolTimeCell: selectedSchoolTimeCell.value,
          ),
          appBar: const CustomAppBar(
            title: Text(
              "Stundenplan",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: WeeklySchedule(
              onLessonEdit: (lesson) async {
                final result = await showDialog<Lesson>(
                  context: context,
                  builder: (context) => EditLessonDialog(
                    lesson: lesson,
                    schoolTimeCell: selectedSchoolTimeCell.value,
                  ),
                );

                if (result != null) {
                  await ref.read(weeklyScheduleProvider.notifier).editLesson(
                        lesson: result,
                      );
                }
              },
              onWeekTapped: () {
                ref.read(weekProvider.notifier).state = week.next();
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
              week: week,
            ),
          ),
        );
      },
    );
  }
}
