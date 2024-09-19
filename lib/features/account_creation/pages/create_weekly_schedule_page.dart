import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/common/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/weekly_schedule.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';

class CreateWeeklySchedulePage extends StatefulWidget {
  const CreateWeeklySchedulePage({super.key});

  @override
  State<CreateWeeklySchedulePage> createState() =>
      _CreateWeeklySchedulePageState();
}

class _CreateWeeklySchedulePageState extends State<CreateWeeklySchedulePage> {
  // These variables are used to interact with the weekly schedule
  SchoolTimeCell? selectedSchoolTimeCell;
  Week week = Week.all;

  // These variables are used to create the weekly schedule
  Set<TimeSpan> timeSpans = {
    const TimeSpan(
      from: TimeOfDay(hour: 7, minute: 30),
      to: TimeOfDay(hour: 9, minute: 00),
    ),
  };
  List<Lesson> lessons = [];

  // Variables only used to show already created subjects and teachers
  List<Subject> subjects = [];
  List<Teacher> teachers = [];

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  timeSpans = {...timeSpans, result};
                });
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
            onPressed: selectedSchoolTimeCell == null
                ? null
                : () async {
                    final result = await _showEditLessonDialog<Lesson>();

                    if (result != null) {
                      setState(() {
                        lessons = [...lessons, result];
                      });
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
          WeeklyScheduleData? data;
          if (lessons.isNotEmpty || timeSpans.isNotEmpty) {
            data = WeeklyScheduleData(
              lessons: lessons,
              timeSpans: timeSpans,
            );
          }

          await context.pushRoute(
            ConfigureHobbyRoute(
              weeklyScheduleData: data,
              subjects: subjects.getListOrNull() as List<Subject>,
              teachers: teachers.getListOrNull() as List<Teacher>,
            ),
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
              lesson: lesson,
            );

            if (result != null) {
              setState(() {
                List<Lesson> oldLessons = List.from(lessons);
                oldLessons.removeWhere((lesson) => lesson.uuid == result.uuid);
                lessons = [...oldLessons, result];
              });
            }
          },
          onWeekTapped: () {
            setState(() {
              week = week.next();
            });
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
              setState(() {
                // Delete the time span from the time spans
                timeSpans = timeSpans
                    .where((timeSpan) => timeSpan != timeSpanToDelete)
                    .toSet();

                // Delete all lessons for the time span
                lessons.removeWhere(
                  (lesson) => lesson.timeSpan == timeSpanToDelete,
                );
              });
            }
          },
          onSchoolTimeCellSelected: (schoolTimeCell) async {
            // Select the cell. If the cell is already selected, unselect it
            setState(() {
              selectedSchoolTimeCell = schoolTimeCell == selectedSchoolTimeCell
                  ? null
                  : schoolTimeCell;
            });
          },
          selectedSchoolTimeCell: selectedSchoolTimeCell,
          timeSpans: timeSpans,
          teachers: teachers,
          subjects: subjects,
          lessons: lessons,
          week: week,
        ),
      ),
    );
  }

  Future<T?> _showEditLessonDialog<T>({Lesson? lesson}) async {
    return await showDialog<T>(
      context: context,
      builder: (context) => EditLessonDialog(
        lesson: lesson,
        schoolTimeCell: selectedSchoolTimeCell,
        subjects: subjects,
        teachers: teachers,
        onLessonDeleted: (lesson) async {
          setState(() {
            lessons.removeWhere((l) => l.uuid == lesson.uuid);
          });

          SnackBarService.show(
            context: context,
            content: Text(
              "Schulstunde ${lesson.getSubject(subjects)!.name} gelöscht",
            ),
            type: CustomSnackbarType.info,
          );
          Navigator.of(context).pop();
        },
        onSubjectChanged: (subject) {
          final index = subjects.indexWhere((s) => s.uuid == subject.uuid);

          setState(() {
            if (index == -1) {
              subjects = [...subjects, subject];
            } else {
              subjects = [
                ...subjects..[index] = subject,
              ];
            }
          });
        },
        onTeacherChanged: (teacher) {
          final index = teachers.indexWhere((t) => t.uuid == teacher.uuid);

          setState(() {
            if (index == -1) {
              teachers = [...teachers, teacher];
            } else {
              teachers = [
                ...teachers..[index] = teacher,
              ];
            }
          });
        },
      ),
    );
  }
}
