import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SchoolTimeCell extends Equatable {
  final Weekday weekday;
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
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday;

  int get weekdayAsInt {
    switch (this) {
      case Weekday.monday:
        return 1;
      case Weekday.tuesday:
        return 2;
      case Weekday.wednesday:
        return 3;
      case Weekday.thursday:
        return 4;
      case Weekday.friday:
        return 5;
    }
  }
}

/// The gender.
enum Gender {
  male,
  female,
  divers;

  String get salutation {
    switch (this) {
      case Gender.male:
        return "Herr";
      case Gender.female:
        return "Frau";
      case Gender.divers:
        return "";
    }
  }

  String get gender {
    switch (this) {
      case Gender.male:
        return "Männlich";
      case Gender.female:
        return "Weiblich";
      case Gender.divers:
        return "Divers";
    }
  }

  static List<String> get gendersAsList => [
        "Männlich",
        "Weiblich",
        "Divers",
      ];

  static Gender fromString(String value) {
    switch (value) {
      case "Männlich":
        return Gender.male;
      case "Weiblich":
        return Gender.female;
      default:
        return Gender.divers;
    }
  }
}

/// An enum to represent the week. Either A or B or All
enum Week {
  a(name: "A"),
  b(name: "B"),
  all(name: "A & B");

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
