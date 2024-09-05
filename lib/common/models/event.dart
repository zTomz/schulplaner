import 'dart:ui';

/// An event in the calendar
class Event {
  /// The name of the event
  final String name;

  /// Optional. The description of the event
  final String? description;

  /// The color of the event
  final Color color;

  /// The date of the event
  final EventDate date;

  /// The type of repeating event. E. g. daily, weekly, monthly, yearly
  final RepeatingEventType? repeatingEventType;

  /// A unique identifier
  final String uuid;

  Event({
    required this.name,
    this.description,
    required this.color,
    required this.date,
    this.repeatingEventType,
    required this.uuid,
  });
}

/// A date with a duration
class EventDate {
  /// The date of the event
  final DateTime date;

  /// How long the event lasts
  final Duration duration;

  /// A unique identifier
  final String uuid;

  EventDate({
    required this.date,
    required this.duration,
    required this.uuid,
  });
}

/// The type of repeating event. E. g. daily, weekly, monthly, yearly
enum RepeatingEventType {
  daily,
  weekly,
  monthly,
  yearly;
}
