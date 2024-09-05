// Models containing time information. E. g. a time span, a week or a weekday

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

/// A class holding a day and a timespan of that day. Used for [Hobby] class
class TimeInDay {
  final Weekday day;
  final TimeSpan timeSpan;

  const TimeInDay({
    required this.day,
    required this.timeSpan,
  });
}

/// The days of a week. From Monday to Friday
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

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
      case Weekday.saturday:
        return 6;
      case Weekday.sunday:
        return 7;
    }
  }

  static List<Weekday> get mondayToFriday {
    return [
      Weekday.monday,
      Weekday.tuesday,
      Weekday.wednesday,
      Weekday.thursday,
      Weekday.friday
    ];
  }

  String get name {
    switch (this) {
      case Weekday.monday:
        return "Montag";
      case Weekday.tuesday:
        return "Dienstag";
      case Weekday.wednesday:
        return "Mittwoch";
      case Weekday.thursday:
        return "Donnerstag";
      case Weekday.friday:
        return "Freitag";
      case Weekday.saturday:
        return "Samstag";
      case Weekday.sunday:
        return "Sonntag";
    }
  }
}