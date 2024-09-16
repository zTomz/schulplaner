// Models used for the weekly schedule

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';

import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';

/// Represents a lesson in the weekly schedule
class Lesson extends Equatable {
  final TimeSpan timeSpan;
  final Weekday weekday;
  final Week week;
  final String subjectUuid;
  final String room;
  final String uuid;

  const Lesson({
    required this.timeSpan,
    required this.weekday,
    required this.week,
    required this.subjectUuid,
    required this.room,
    required this.uuid,
  });

  @override
  List<Object?> get props => [timeSpan, weekday, week, subjectUuid, room, uuid];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'timeSpan': timeSpan.toMap(),
      'weekday': weekday.toMap(),
      'week': week.toMap(),
      'subjectUuid': subjectUuid,
      'room': room,
      'uuid': uuid,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      timeSpan: TimeSpan.fromMap(map['timeSpan']),
      weekday: Weekday.fromMap(map['weekday']),
      week: Week.fromMap(map['week']),
      subjectUuid: map['subjectUuid'] ?? '',
      room: map['room'] ?? '',
      uuid: map['uuid'] ?? '',
    );
  }

  Subject? getSubject(List<Subject> subjects) {
    return firstWhereOrNull(
      subjects,
      (subject) => subject.uuid == subjectUuid,
    );
  }
}

/// Represents a subject
class Subject {
  /// The name of the subject. E. g. Math, English etc.
  final String name;

  /// The uuid of the teacher of the subject
  final String teacherUuid;

  /// The color of the subject
  final Color color;

  /// A unique identifier
  final String uuid;

  const Subject({
    required this.name,
    required this.teacherUuid,
    required this.color,
    required this.uuid,
  });

  @override
  String toString() =>
      'Subject(name: $name, teacherUuid: $teacherUuid, color: $color, uuid: $uuid)';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teacherUuid': teacherUuid,
      'color': color.value,
      'uuid': uuid,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      name: map['name'] ?? '',
      // Checks if the teacher exists in the database, if it does, it uses the current data of
      // the teacher, which is from another doc in firebase.
      teacherUuid: map['teacherUuid'],
      color: Color(map['color']),
      uuid: map['uuid'] ?? '',
    );
  }

  Teacher? getTeacher(List<Teacher> teachers) {
    return firstWhereOrNull(
      teachers,
      (teacher) => teacher.uuid == teacherUuid,
    );
  }
}

/// Represents a teacher
class Teacher {
  String? firstName;
  final String lastName;
  final Gender gender;
  final String? email;
  final bool favorite;
  final String uuid;

  Teacher({
    this.firstName,
    required this.lastName,
    required this.gender,
    this.email,
    this.favorite = false,
    required this.uuid,
  });

  @override
  String toString() =>
      'Teacher(firstName: $firstName, lastName: $lastName, gender: $gender, email: $email, favorite: $favorite, uuid: $uuid)';

  /// Get the salutation of the teacher. E. g. "Herr Schulze"
  String get salutation => "${gender.salutation} $lastName";

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.toMap(),
      'email': email,
      'favorite': favorite,
      'uuid': uuid,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      firstName: map['firstName'],
      lastName: map['lastName'] ?? '',
      gender: Gender.fromMap(map['gender']),
      email: map['email'],
      favorite: map['favorite'] ?? false,
      uuid: map['uuid'] ?? '',
    );
  }
}
