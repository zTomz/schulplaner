// Models used for the weekly schedule

import 'dart:convert';
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

  Map<String, dynamic> toMap() {
    return {
      'timeSpan': timeSpan.toMap(),
      'weekday': weekday.toMap(),
      'week': week.toMap(),
      'subject': subject.toMap(),
      'room': room,
      'uuid': uuid,
    };
  }

  factory Lesson.fromMap(
    Map<String, dynamic> map, {
    List<Teacher>? teachers,
  }) {
    return Lesson(
      timeSpan: TimeSpan.fromMap(map['timeSpan']),
      weekday: Weekday.fromMap(map['weekday']),
      week: Week.fromMap(map['week']),
      subject: Subject.fromMap(
        map['subject'],
        teachers: teachers,
      ),
      room: map['room'] ?? '',
      uuid: map['uuid'] ?? '',
    );
  }
}

/// Represents a subject
class Subject {
  /// The name of the subject. E. g. Math, English etc.
  final String name;

  /// The teacher of the subject
  final Teacher teacher;

  /// The color of the subject
  final Color color;

  /// A unique identifier
  final String uuid;

  const Subject({
    required this.name,
    required this.teacher,
    required this.color,
    required this.uuid,
  });

  @override
  String toString() => 'Subject(name: $name, teacher: $teacher, color: $color, uuid: $uuid)';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teacher': teacher.toMap(),
      'color': color.value,
      'uuid': uuid,
    };
  }

  factory Subject.fromMap(
    Map<String, dynamic> map, {
    List<Teacher>? teachers,
  }) {
    final teacher = Teacher.fromMap(map['teacher']);

    return Subject(
      name: map['name'] ?? '',
      // Checks if the teacher exists in the database, if it does, it uses the current data of
      // the teacher, which is from another doc in firebase.
      teacher:
          teachers?.where((t) => t.uuid == teacher.uuid).firstOrNull ?? teacher,
      color: Color(map['color']),
      uuid: map['uuid'] ?? '',
    );
  }

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source));
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
  String toString() => 'Teacher(firstName: $firstName, lastName: $lastName, gender: $gender, email: $email, favorite: $favorite, uuid: $uuid)';

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
