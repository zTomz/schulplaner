import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/services/exeption_handler_service.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/functions/close_all_dialogs.dart';
import 'package:schulplaner/shared/functions/handle_state_change_database.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';
import 'package:schulplaner/shared/widgets/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/weekly_schedule.dart';

@RoutePage()
class WeeklySchedulePage extends HookConsumerWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleStream = ref.watch(weeklyScheduleProvider);

    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.a);

    return weeklyScheduleStream.when(
      data: (data) {
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
                    try {
                      await DatabaseService.uploadWeeklySchedule(
                        weeklyScheduleData: WeeklyScheduleData(
                          timeSpans: {...timeSpans, result},
                          lessons: lessons,
                          teachers: teachers,
                          subjects: subjects,
                        ),
                      );
                    } catch (error) {
                      if (context.mounted) {
                        ExeptionHandlerService.handleExeption(context, error);
                      }
                    }
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
                          selectedSchoolTimeCell: selectedSchoolTimeCell.value!,
                          teachers: teachers,
                          subjects: subjects,
                          lessons: lessons,
                          timeSpans: timeSpans,
                        );

                        if (result != null) {
                          List<Lesson> updatedLessons = List.from(lessons);
                          updatedLessons.removeWhere(
                            (lesson) => lesson.uuid == result.uuid,
                          );
                          updatedLessons.add(result);

                          try {
                            await DatabaseService.uploadWeeklySchedule(
                              weeklyScheduleData: WeeklyScheduleData(
                                timeSpans: timeSpans,
                                lessons: updatedLessons,
                                teachers: teachers,
                                subjects: subjects,
                              ),
                            );
                          } catch (error) {
                            if (context.mounted) {
                              ExeptionHandlerService.handleExeption(
                                  context, error);
                            }
                          }
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
                  lesson: lesson,
                  subjects: subjects,
                  selectedSchoolTimeCell: selectedSchoolTimeCell.value,
                  teachers: teachers,
                  lessons: lessons,
                  timeSpans: timeSpans,
                );

                if (result != null) {
                  lessons.removeWhere(
                    (lesson) => lesson.uuid == result.uuid,
                  );
                  lessons.add(result);

                  try {
                    await DatabaseService.uploadWeeklySchedule(
                      weeklyScheduleData: WeeklyScheduleData(
                        timeSpans: timeSpans,
                        lessons: lessons,
                        teachers: teachers,
                        subjects: subjects,
                      ),
                    );
                  } catch (error) {
                    if (context.mounted) {
                      ExeptionHandlerService.handleExeption(context, error);
                    }
                  }
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
                  timeSpans = timeSpans
                      .where((timeSpan) => timeSpan != timeSpanToDelete)
                      .toSet();

                  // Delete all lessons for the time span
                  lessons.removeWhere(
                    (lesson) => lesson.timeSpan == timeSpanToDelete,
                  );

                  try {
                    await DatabaseService.uploadWeeklySchedule(
                      weeklyScheduleData: WeeklyScheduleData(
                        timeSpans: timeSpans,
                        lessons: lessons,
                        teachers: teachers,
                        subjects: subjects,
                      ),
                    );
                  } catch (error) {
                    if (context.mounted) {
                      ExeptionHandlerService.handleExeption(context, error);
                    }
                  }
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
      error: (_, __) {
        return const DataErrorWidget();
      },
      loading: () => const DataLoadingWidget(),
    );
  }
}

Future<T?> _showEditLessonDialog<T>(
  BuildContext context, {
  Lesson? lesson,
  SchoolTimeCell? selectedSchoolTimeCell,
  required List<Teacher> teachers,
  required List<Subject> subjects,
  required List<Lesson> lessons,
  required Set<TimeSpan> timeSpans,
}) async {
  return await showDialog<T?>(
    context: context,
    builder: (context) => EditLessonDialog(
      lesson: lesson,
      subjects: subjects,
      teachers: teachers,
      schoolTimeCell: selectedSchoolTimeCell,
      onLessonDeleted: lesson != null
          ? (lesson) async {
              lessons.removeWhere(
                (l) => l.uuid == lesson.uuid,
              );

              try {
                await DatabaseService.uploadWeeklySchedule(
                  weeklyScheduleData: WeeklyScheduleData(
                    timeSpans: timeSpans,
                    lessons: lessons,
                    subjects: subjects,
                    teachers: teachers,
                  ),
                );
              } catch (error) {
                if (context.mounted) {
                  closeAllDialogs(context);
                }
                if (context.mounted) {
                  ExeptionHandlerService.handleExeption(context, error);
                }
                return;
              }

              if (context.mounted) {
                await closeAllDialogs(context);
              }
              if (context.mounted) {
                SnackBarService.show(
                  context: context,
                  content: Text(
                    "Die Schulstunde ${lesson.getSubject(subjects)?.name ?? ""} wurde gelöscht.",
                  ),
                  type: CustomSnackbarType.info,
                );
              }
            }
          : null,
      onSubjectCreated: (subject) =>
          onSubjectChanged(context, subject, subjects),
      onSubjectEdited: (subject) =>
          onSubjectChanged(context, subject, subjects),
      onTeacherCreated: (teacher) =>
          onTeacherChanged(context, teacher, teachers),
      onTeacherEdited: (teacher) =>
          onTeacherChanged(context, teacher, teachers),
    ),
  );
}
