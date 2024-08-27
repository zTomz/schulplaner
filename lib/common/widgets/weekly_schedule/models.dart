import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SchoolTimeCell extends Equatable {
  final Weekdays weekday;
  final TimeSpan timeSpan;

  const SchoolTimeCell({
    required this.weekday,
    required this.timeSpan,
  });

  @override
  List<Object?> get props => [weekday, timeSpan];
}

/// Represents a lesson in the weekly schedule
class Lesson extends Equatable {
  final TimeSpan timeSpan;
  final Weekdays weekday;
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
  final String firstName;
  final String lastName;
  final Gender gender;
  final String email;
  final Subject? subject;
  final bool favorite;
  final String uuid;

  Teacher({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    this.subject,
    required this.favorite,
    required this.uuid,
  });
}

/// A time span. Used to represent the time of a lesson
class TimeSpan extends Equatable {
  final TimeOfDay from;
  final TimeOfDay to;

  const TimeSpan({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];

  String toFormattedString() {
    return "${from.hour.toString().padLeft(2, "0")}:${from.minute.toString().padLeft(2, "0")} - ${to.hour.toString().padLeft(2, "0")}:${to.minute.toString().padLeft(2, "0")} Uhr";
  }

  TimeSpan copyWith({
    TimeOfDay? from,
    TimeOfDay? to,
  }) {
    return TimeSpan(
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

/// The days of a week. From Monday to Friday
enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday;

  int get weekdayAsInt {
    switch (this) {
      case Weekdays.monday:
        return 1;
      case Weekdays.tuesday:
        return 2;
      case Weekdays.wednesday:
        return 3;
      case Weekdays.thursday:
        return 4;
      case Weekdays.friday:
        return 5;
    }
  }
}

/// The gender.
enum Gender {
  male,
  female,
  unspecified;

  String get genderAsString {
    switch (this) {
      case Gender.male:
        return "Herr";
      case Gender.female:
        return "Frau";
      case Gender.unspecified:
        return "";
    }
  }
}

/// An enum to represent the week. Either A or B or All
enum Week {
  a(name: "A"),
  b(name: "B"),
  all(name: "All");

  final String name;

  const Week({
    required this.name,
  });

  /// Returns the next week
  Week next() {
    switch (this) {
      case Week.a:
        return Week.b;
      case Week.b:
        return Week.all;
      case Week.all:
        return Week.a;
    }
  }
}
