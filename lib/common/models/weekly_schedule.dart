// Models used for the weekly schedule

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';

/// Represents a lesson in the weekly schedule
class Lesson extends Equatable {
  final TimeSpan timeSpan;
  final Weekday weekday;
  final Week week;
  final Subject subject;
  final String room;
  final String uuid;

  const Lesson({
    required this.timeSpan,
    required this.weekday,
    required this.week,
    required this.subject,
    required this.room,
    required this.uuid,
  });

  @override
  List<Object?> get props => [timeSpan, weekday, week, subject, room, uuid];

  @override
  bool get stringify => true;
}

/// Represents a subject
class Subject {
  final String subject;
  final Teacher teacher;
  final Color color;
  final String uuid;

  const Subject({
    required this.subject,
    required this.teacher,
    required this.color,
    required this.uuid,
  });
}

/// Represents a teacher
class Teacher {
  String? firstName;
  final String lastName;
  final Gender gender;
  final String? email;
  final Subject? subject;
  final bool favorite;
  final String uuid;

  Teacher({
    this.firstName,
    required this.lastName,
    required this.gender,
    this.email,
    this.subject,
    this.favorite = false,
    required this.uuid,
  });

  /// Get the salutation of the teacher. E. g. "Herr Schulze"
  String get salutation => "${gender.salutation} $lastName";
}