// Models used for the weekly schedule

import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

/// This class contains all data used by the weekly schedule
class WeeklyScheduleData {
  final Set<TimeSpan> timeSpans;
  final List<Lesson> lessons;
  final List<Subject> subjects;
  final List<Teacher> teachers;

  WeeklyScheduleData({
    required this.timeSpans,
    required this.lessons,
    required this.subjects,
    required this.teachers,
  });

  WeeklyScheduleData copyWith({
    Set<TimeSpan>? timeSpans,
    List<Lesson>? lessons,
    List<Subject>? subjects,
    List<Teacher>? teachers,
  }) {
    return WeeklyScheduleData(
      timeSpans: timeSpans ?? this.timeSpans,
      lessons: lessons ?? this.lessons,
      subjects: subjects ?? this.subjects,
      teachers: teachers ?? this.teachers,
    );
  }

  

  Map<String, dynamic> toMap() {
    return {
      'timeSpans': timeSpans.map((x) => x.toMap()).toList(),
      'lessons': lessons.map((x) => x.toMap()).toList(),
      'subjects': subjects.map((x) => x.toMap()).toList(),
      'teachers': teachers.map((x) => x.toMap()).toList(),
    };
  }

  factory WeeklyScheduleData.fromMap(Map<String, dynamic> map) {
    return WeeklyScheduleData(
      timeSpans: Set<TimeSpan>.from(map['timeSpans']?.map((x) => TimeSpan.fromMap(x))),
      lessons: List<Lesson>.from(map['lessons']?.map((x) => Lesson.fromMap(x))),
      subjects: List<Subject>.from(map['subjects']?.map((x) => Subject.fromMap(x))),
      teachers: List<Teacher>.from(map['teachers']?.map((x) => Teacher.fromMap(x))),
    );
  }
}

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

  /// Get a complete map. This means, a map with a Subject object and a Teacher object will be returned,
  /// instead of displaying only the uuid.
  Map<String, dynamic> getCompleteMap(
    List<Subject> subjects,
    List<Teacher> teachers,
  ) {
    final subject = getSubject(subjects);

    return {
      'subject': subject?.getCompleteMap(teachers),
      'timeSpan': timeSpan.toMap(),
      'weekday': weekday.toMap(),
      'week': week.toMap(),
      'room': room,
      'uuid': uuid,
    };
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

  /// Get a complete map. This means, a map with a Subject object and a Teacher object will be returned,
  /// instead of displaying only the uuid.
  Map<String, dynamic> getCompleteMap(List<Teacher> teachers) {
    final teacher = getTeacher(teachers);

    return {
      'name': name,
      'teacher': teacher?.toMap(),
      'color': color.value,
      'uuid': uuid,
    };
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
