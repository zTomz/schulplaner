import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

class CreateWeeklyScheduleNotifier extends StateNotifier<WeeklyScheduleData> {
  CreateWeeklyScheduleNotifier()
      : super(
          WeeklyScheduleData(
            timeSpans: {
              const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
            },
            lessons: [],
            subjects: [],
            teachers: [],
          ),
        );

  /// Add a time span to the list of time spans
  void addTimeSpan(TimeSpan timeSpan) {
    state = state.copyWith(
      timeSpans: {
        ...state.timeSpans,
        timeSpan,
      },
    );
  }

  /// Delete a time span from the list of time spans and remove all lessons in that time span
  void deleteTimeSpan(TimeSpan timeSpan) {
    state = state.copyWith(
      timeSpans: state.timeSpans..remove(timeSpan),
      lessons:
          state.lessons.map((l) => l.timeSpan == timeSpan ? l : l).toList(),
    );
  }

  /// Add a lesson to the list of lessons
  void addLesson(Lesson lesson) {
    state = state.copyWith(
      lessons: [...state.lessons, lesson],
    );
  }

  /// Edit a lesson in the list of lessons
  void editLesson(Lesson lesson) {
    state = state.copyWith(
      lessons:
          state.lessons.map((l) => l.uuid == lesson.uuid ? lesson : l).toList(),
    );
  }

  /// Delete a lesson from the list of lessons
  void deleteLesson(Lesson lesson) {
    state = state.copyWith(
      lessons: state.lessons.where((l) => l.uuid != lesson.uuid).toList(),
    );
  }

  /// Add a subject to the list of subjects
  void addSubject(Subject subject) {
    state = state.copyWith(
      subjects: [...state.subjects, subject],
    );
  }

  /// Edit an already existing subject
  void editSubject(Subject subject) {
    state = state.copyWith(
      subjects: state.subjects
          .map((s) => s.uuid == subject.uuid ? subject : s)
          .toList(),
    );
  }

  /// Delete a subject from the list of subjects
  void deleteSubject(Subject subject) {
    state = state.copyWith(
      subjects: state.subjects
          .where(
            (element) => element.uuid != subject.uuid,
          )
          .toList(),
      lessons: state.lessons
          .where((lesson) => lesson.subjectUuid != subject.uuid)
          .toList(),
    );
  }

  /// Create a new teacher and add it to the list of teachers
  void createTeacher(Teacher teacher) {
    state = state.copyWith(
      teachers: [...state.teachers, teacher],
    );
  }

  /// Edit an already existing teacher
  void editTeacher(Teacher teacher) {
    state = state.copyWith(
      teachers: state.teachers
          .map((t) => t.uuid == teacher.uuid ? teacher : t)
          .toList(),
    );
  }

  /// Delete a teacher from the list of teachers
  void deleteTeacher(Teacher teacher) {
    final subjects = state.subjects;

    state = state.copyWith(
      teachers: state.teachers
          .where(
            (element) => element.uuid != teacher.uuid,
          )
          .toList(),
      subjects: state.subjects
          .where(
            (element) => element.teacherUuid != teacher.uuid,
          )
          .toList(),
      lessons: state.lessons
          .where(
            (lesson) =>
                lesson.getSubject(subjects)?.teacherUuid != teacher.uuid,
          )
          .toList(),
    );
  }
}
