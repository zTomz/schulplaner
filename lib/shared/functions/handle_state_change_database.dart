import 'package:flutter/material.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/database_service.dart';
import 'package:schulplaner/shared/services/exeption_handler_service.dart';

/// A method to handle an edit on a subject. This method is used, when an account exists
Future<void> onSubjectChanged(
  BuildContext context,
  Subject subject,
  List<Subject> subjects,
) async {
  final index = subjects.indexWhere((s) => s.uuid == subject.uuid);

  List<Subject> updatedSubjects = [];

  if (index == -1) {
    updatedSubjects = [...subjects, subject];
  } else {
    updatedSubjects = subjects;
    updatedSubjects[index] = subject;
  }

  try {
    await DatabaseService.uploadSubjects(
      subjects: updatedSubjects,
    );
  } catch (error) {
    if (context.mounted) {
      ExeptionHandlerService.handleExeption(context, error);
    }
  }
}

/// A method to handle an edit on a teacher. This method is used, when an account exists
Future<void> onTeacherChanged(
  BuildContext context,
  Teacher teacher,
  List<Teacher> teachers,
) async {
  final index = teachers.indexWhere((t) => t.uuid == teacher.uuid);
  List<Teacher> updatedTeachers = [];

  if (index == -1) {
    updatedTeachers = [...teachers, teacher];
  } else {
    updatedTeachers = teachers;
    updatedTeachers[index] = teacher;
  }

  try {
    await DatabaseService.uploadTeachers(
      teachers: updatedTeachers,
    );
  } catch (error) {
    if (context.mounted) {
      ExeptionHandlerService.handleExeption(context, error);
    }
  }
}
