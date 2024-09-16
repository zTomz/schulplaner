import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';
import 'package:schulplaner/common/services/database_service.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/weekly_schedule.dart';

@RoutePage()
class WeeklySchedulePage extends HookWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.a);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService.weeklyScheduleCollection.snapshots(),
      builder: (context, snapshot) {
        // TODO: Better handle error or no data from snapshot
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error"));
        }

        final data = _convertSnapshotToData(data: snapshot.data!);

        List<Lesson> lessons = data.$1;
        Set<TimeSpan> timeSpans = data.$2;
        final List<Teacher> teachers = data.$3;
        final List<Subject> subjects = data.$4;

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

                  if (result != null && context.mounted) {
                    await DatabaseService.uploadWeeklySchedule(
                      context,
                      weeklyScheduleData: WeeklyScheduleData(
                        timeSpans: {...timeSpans, result},
                        lessons: lessons,
                      ),
                    );
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

                        if (result != null && context.mounted) {
                          List<Lesson> updatedLessons = List.from(lessons);
                          updatedLessons.removeWhere(
                            (lesson) => lesson.uuid == result.uuid,
                          );
                          updatedLessons.add(result);

                          await DatabaseService.uploadWeeklySchedule(
                            context,
                            weeklyScheduleData: WeeklyScheduleData(
                              timeSpans: timeSpans,
                              lessons: updatedLessons,
                            ),
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
                  lesson: lesson,
                  subjects: subjects,
                  selectedSchoolTimeCell: selectedSchoolTimeCell.value,
                  teachers: teachers,
                  lessons: lessons,
                  timeSpans: timeSpans,
                );

                if (result != null && context.mounted) {
                  lessons.removeWhere(
                    (lesson) => lesson.uuid == result.uuid,
                  );
                  lessons.add(result);

                  await DatabaseService.uploadWeeklySchedule(
                    context,
                    weeklyScheduleData: WeeklyScheduleData(
                      timeSpans: timeSpans,
                      lessons: lessons,
                    ),
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
                  // Delete the time span from the time spans
                  timeSpans = timeSpans
                      .where((timeSpan) => timeSpan != timeSpanToDelete)
                      .toSet();

                  // Delete all lessons for the time span
                  lessons.removeWhere(
                    (lesson) => lesson.timeSpan == timeSpanToDelete,
                  );

                  if (context.mounted) {
                    await DatabaseService.uploadWeeklySchedule(
                      context,
                      weeklyScheduleData: WeeklyScheduleData(
                        timeSpans: timeSpans,
                        lessons: lessons,
                      ),
                    );
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
              timeSpans: timeSpans,
              teachers: teachers,
              subjects: subjects,
              lessons: lessons,
              week: week.value,
            ),
          ),
        );
      },
    );
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

                await DatabaseService.uploadWeeklySchedule(
                  context,
                  weeklyScheduleData: WeeklyScheduleData(
                    timeSpans: timeSpans,
                    lessons: lessons,
                  ),
                );

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
        onSubjectChanged: (subject) async {
          final index = subjects.indexWhere((s) => s.uuid == subject.uuid);

          List<Subject> updatedSubjects = [];

          if (index == -1) {
            updatedSubjects = [...subjects, subject];
          } else {
            updatedSubjects = subjects;
            updatedSubjects[index] = subject;
          }

          await DatabaseService.uploadSubjects(
            context,
            subjects: updatedSubjects,
          );
        },
        onTeacherChanged: (teacher) async {
          final index = teachers.indexWhere((t) => t.uuid == teacher.uuid);
          List<Teacher> updatedTeachers = [];

          if (index == -1) {
            updatedTeachers = [...teachers, teacher];
          } else {
            updatedTeachers = teachers;
            updatedTeachers[index] = teacher;
          }

          await DatabaseService.uploadTeachers(
            context,
            teachers: updatedTeachers,
          );
        },
      ),
    );
  }

  (
    List<Lesson> lessons,
    Set<TimeSpan> timeSpans,
    List<Teacher> teachers,
    List<Subject> subjects,
  ) _convertSnapshotToData({
    required QuerySnapshot<Map<String, dynamic>> data,
  }) {
    List<Lesson> lessons = [];
    Set<TimeSpan> timeSpans = {};
    List<Teacher> teachers = [];
    List<Subject> subjects = [];

    // Get the teachers
    final teacherDoc =
        data.docs.where((doc) => doc.id == "teachers").firstOrNull;
    if (teacherDoc != null) {
      final teacherData = teacherDoc.data();
      for (final entry in teacherData.entries) {
        teachers.add(
            Teacher.fromMap(teacherData[entry.key] as Map<String, dynamic>));
      }
    }

    // Get the lessons
    final lessonDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;
    if (lessonDoc != null) {
      final lessonData = lessonDoc.data();

      for (final entry in lessonData["lessons"].entries) {
        lessons.add(Lesson.fromMap(
          lessonData["lessons"][entry.key] as Map<String, dynamic>,
        ));
      }
    }

    // Get the time spans
    final timeSpanDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;
    if (timeSpanDoc != null) {
      final timeSpanData = timeSpanDoc.data();

      for (int i = 0;
          i < (timeSpanData["timeSpans"] as List<dynamic>).length;
          i++) {
        timeSpans.add(TimeSpan.fromMap(
          timeSpanData["timeSpans"][i] as Map<String, dynamic>,
        ));
      }
    }

    // Get the subjects
    final subjectDoc =
        data.docs.where((doc) => doc.id == "subjects").firstOrNull;
    if (subjectDoc != null) {
      final subjectData = subjectDoc.data();
      for (final entry in subjectData.entries) {
        subjects.add(
          Subject.fromMap(subjectData[entry.key] as Map<String, dynamic>),
        );
      }
    }

    return (
      lessons,
      timeSpans,
      teachers,
      subjects,
    );
  }
}
