import 'dart:ui';

import 'package:schulplaner/common/models/weekly_schedule.dart';

/// An event in the calendar
abstract class Event {
  /// The name of the event
  final String name;

  /// Optional. The description of the event
  final String? description;

  /// The color of the event
  final Color color;

  /// A unique identifier
  final String uuid;

  Event({
    required this.name,
    this.description,
    required this.color,
    // required this.date,
    // this.repeatingEventType,
    required this.uuid,
  });
}

/// A homework event
class HomeworkEvent extends Event {
  /// The date, when the homework event is due
  final EventDate date;

  /// The subject of the homework. E. g. Math, English etc.
  final Subject subject;

  HomeworkEvent({
    required super.description,
    required super.color,
    required super.uuid,
    required this.date,
    required this.subject,
  }) : super(
    name: "Hausaufgabe ${subject.name}",
  );
}

/// A test event.
class TestEvent extends Event {
  /// When the test takes place
  final DateTime deadline;

  /// The dates, when the pratice for the test is due
  final List<EventDate> praticeDates;

  /// The subject of the test. E. g. Math, English etc.
  final Subject subject;

  TestEvent({
    required super.description,
    required super.color,
    required super.uuid,
    required this.deadline,
    required this.praticeDates,
    required this.subject,
  }) : super(
    name: "Leistungskontrolle ${subject.name}",
  );
}

class FixedEvent extends Event {
  /// When the event is due
  final EventDate date;

  /// Optional. Where the event takes place
  final String? place;

  FixedEvent({
    required super.name,
    required super.description,
    required super.color,
    required this.date,
    required super.uuid,
    this.place,
  });
}

class RepeatingEvent extends Event {
  /// When the first event is due
  final EventDate date;

  /// The type of repeating event. E. g. daily, weekly, monthly, yearly
  final RepeatingEventType repeatingEventType;

  RepeatingEvent({
    required super.name,
    required super.description,
    required super.color,
    required super.uuid,
    required this.date,
    required this.repeatingEventType,
  });
}

// TODO: Add homework and other classes here. These should be subclasses of [Event]

/// A date with a duration
class EventDate {
  /// The date of the event
  final DateTime date;

  /// How long the event lasts
  final Duration duration;

  EventDate({
    required this.date,
    required this.duration,
  });
}

/// The type of repeating event. E. g. daily, weekly, monthly, yearly
enum RepeatingEventType {
  daily,
  weekly,
  monthly,
  yearly;
}
