import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/presentation/providers/create_weekly_schedule_provider.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';
import 'package:schulplaner/shared/widgets/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/gradient_scaffold.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/weekly_schedule.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class CreateWeeklySchedulePage extends HookConsumerWidget {
  const CreateWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.all);

    final weeklyScheduleData = ref.watch(createWeeklyScheduleProvider);

    return GradientScaffold(
      appBar: CustomAppBar(
        title: Text(
          "Stundenplan erstellen",
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
                ref
                    .read(createWeeklyScheduleProvider.notifier)
                    .addTimeSpan(result);
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
                      lesson: null,
                      selectedSchoolTimeCell: selectedSchoolTimeCell.value,
                      weeklyScheduleData: weeklyScheduleData,
                    );

                    if (result != null) {
                      ref.read(createWeeklyScheduleProvider.notifier).addLesson(
                            result,
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
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          await context.pushRoute(
            const ConfigureHobbyRoute(),
          );
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
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
              weeklyScheduleData: weeklyScheduleData,
            );

            if (result != null) {
              ref
                  .read(createWeeklyScheduleProvider.notifier)
                  .editLesson(result);
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
              ref.read(createWeeklyScheduleProvider.notifier).deleteTimeSpan(
                    timeSpanToDelete,
                  );
            }
          },
          onSchoolTimeCellSelected: (schoolTimeCell) async {
            // Select the cell. If the cell is already selected, unselect it
            selectedSchoolTimeCell.value =
                schoolTimeCell == selectedSchoolTimeCell.value
                    ? null
                    : schoolTimeCell;
          },
          selectedSchoolTimeCell: selectedSchoolTimeCell.value,
          data: weeklyScheduleData,
          week: week.value,
        ),
      ),
    );
  }

  Future<T?> _showEditLessonDialog<T>(
    BuildContext context,
    WidgetRef ref, {
    required SchoolTimeCell? selectedSchoolTimeCell,
    required WeeklyScheduleData weeklyScheduleData,
    required Lesson? lesson,
  }) async {
    return await showDialog<T>(
      context: context,
      builder: (context) => EditLessonDialog(
        lesson: lesson,
        schoolTimeCell: selectedSchoolTimeCell,
        subjects: weeklyScheduleData.subjects,
        teachers: weeklyScheduleData.teachers,
        onLessonDeleted: (lesson) {
          ref.read(createWeeklyScheduleProvider.notifier).deleteLesson(
                lesson,
              );

          SnackBarService.show(
            context: context,
            content: Text(
              "Schulstunde ${lesson.getSubject(weeklyScheduleData.subjects)?.name ?? ""} gelöscht",
            ),
            type: CustomSnackbarType.info,
          );
          Navigator.of(context).pop();
        },
        onSubjectCreated: (subject) {
          ref.read(createWeeklyScheduleProvider.notifier).addSubject(subject);
        },
        onSubjectEdited: (subject) {
          ref.read(createWeeklyScheduleProvider.notifier).editSubject(subject);
        },
        onTeacherCreated: (teacher) {
          ref
              .read(createWeeklyScheduleProvider.notifier)
              .createTeacher(teacher);
        },
        onTeacherEdited: (teacher) {
          ref.read(createWeeklyScheduleProvider.notifier).editTeacher(teacher);
        },
      ),
    );
  }
}
