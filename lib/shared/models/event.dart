import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:schulplaner/shared/extensions/duration_extension.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

/// An event in the calendar
abstract class Event {
  /// The name of the event
  final String name;

  /// Optional. The description of the event
  final String? description;

  /// When the event is due
  final DateTime date;

  /// The type of the event
  final EventTypes type;

  /// A unique identifier
  final String uuid;

  Event({
    required this.name,
    this.description,
    required this.date,
    required this.type,
    required this.uuid,
  });
}

// TODO: Add homework and other classes here. These should be subclasses of [Event]

/// A homework event
class HomeworkEvent extends Event {
  /// The subject of the homework. E. g. Math, English etc.
  final String subjectUuid;

  /// The date, when the homework should be done
  final ProcessingDate processingDate;

  /// Whether the homework is done
  final bool isDone;

  HomeworkEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.processingDate,
    required this.subjectUuid,
    required this.isDone,
    required super.uuid,
  }) : super(type: EventTypes.homework);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
      'processingDate': processingDate.toMap(),
      'subjectUuid': subjectUuid,
      'description': description,
      'isDone': isDone,
      'uuid': uuid,
    };
  }

  factory HomeworkEvent.fromMap(Map<String, dynamic> map) {
    return HomeworkEvent(
      name: map['name'],
      date: (map['date'] as Timestamp).toDate(),
      processingDate: ProcessingDate.fromMap(map['processingDate']),
      subjectUuid: map['subjectUuid'],
      description: map['description'],
      isDone: map['isDone'],
      uuid: map['uuid'],
    );
  }

  HomeworkEvent copyWith({
    String? name,
    String? description,
    DateTime? date,
    ProcessingDate? processingDate,
    String? subjectUuid,
    bool? isDone,
    String? uuid,
  }) {
    return HomeworkEvent(
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      processingDate: processingDate ?? this.processingDate,
      subjectUuid: subjectUuid ?? this.subjectUuid,
      isDone: isDone ?? this.isDone,
      uuid: uuid ?? this.uuid,
    );
  }

  Map<String, dynamic> getCompleteMap(
    List<Subject> subjects,
    List<Teacher> teachers,
  ) {
    final subject = firstWhereOrNull(
      subjects,
      (s) => s.uuid == subjectUuid,
    );

    return {
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'processingDate': processingDate.toMap(),
      'subject': subject?.getCompleteMap(teachers),
      'description': description,
      'isDone': isDone,
      'uuid': uuid,
    };
  }
}

/// A test event.
class TestEvent extends Event {
  /// The dates, when the pratice for the test is due
  final List<ProcessingDate> praticeDates;

  /// The subject of the test. E. g. Math, English etc.
  final String subjectUuid;

  TestEvent({
    required super.name,
    required super.description,
    required super.uuid,
    required super.date,
    required this.praticeDates,
    required this.subjectUuid,
  }) : super(type: EventTypes.test);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'praticeDates': praticeDates.map((x) => x.toMap()).toList(),
      'subjectUuid': subjectUuid,
      'uuid': uuid,
    };
  }

  factory TestEvent.fromMap(Map<String, dynamic> map) {
    return TestEvent(
      name: map['name'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      praticeDates: List<ProcessingDate>.from(
        map['praticeDates']?.map(
          (x) => ProcessingDate.fromMap(x),
        ),
      ),
      subjectUuid: map['subjectUuid'] ?? '',
      uuid: map['uuid'],
    );
  }

  Map<String, dynamic> getCompleteMap(
    List<Subject> subjects,
    List<Teacher> teachers,
  ) {
    final subject = firstWhereOrNull(
      subjects,
      (s) => s.uuid == subjectUuid,
    );

    return {
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'praticeDates': praticeDates.map((x) => x.toMap()).toList(),
      'subject': subject?.getCompleteMap(teachers),
      'uuid': uuid,
    };
  }
}

class ReminderEvent extends Event {
  /// Optional. Where the event takes place
  final String? place;

  /// The color of the event
  final Color color;

  ReminderEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.color,
    required super.uuid,
    this.place,
  }) : super(type: EventTypes.reminder);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'place': place,
      'color': color.value,
      'date': Timestamp.fromDate(date),
      'uuid': uuid,
    };
  }

  factory ReminderEvent.fromMap(Map<String, dynamic> map) {
    return ReminderEvent(
      name: map['name'],
      description: map['description'],
      place: map['place'],
      color: Color(map['color']),
      date: (map['date'] as Timestamp).toDate(),
      uuid: map['uuid'],
    );
  }
}

class RepeatingEvent extends Event {
  /// The type of repeating event. E. g. daily, weekly, monthly, yearly
  final RepeatingEventType repeatingEventType;

  /// The color of the event
  final Color color;

  RepeatingEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.repeatingEventType,
    required this.color,
    required super.uuid,
  }) : super(type: EventTypes.repeating);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': Timestamp.fromDate(date),
      'repeatingEventType': repeatingEventType.toMap(),
      'color': color.value,
      'uuid': uuid,
    };
  }

  factory RepeatingEvent.fromMap(Map<String, dynamic> map) {
    return RepeatingEvent(
      name: map['name'],
      description: map['description'],
      date: (map['date'] as Timestamp).toDate(),
      repeatingEventType: RepeatingEventType.fromMap(map['repeatingEventType']),
      color: Color(map['color']),
      uuid: map['uuid'],
    );
  }
}

/// A date with a duration.
///
/// When generated with AI, these factors should be taken into account:
/// - When does the event happen
/// - What other events are happening between the current day and when the event is due
/// - How difficult is the event to do
class ProcessingDate {
  /// The date of the event
  final DateTime date;

  /// How long the event lasts
  final Duration duration;

  ProcessingDate({
    required this.date,
    required this.duration,
  });

  String get formattedDate =>
      "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")} Uhr, ${date.day}.${date.month}.${date.year}";

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'duration': duration.toMap(),
    };
  }

  factory ProcessingDate.fromMap(Map<String, dynamic> map) {
    return ProcessingDate(
      date: map['date'] is String
          ? DateTime.parse(map['date'])
          : (map['date'] as Timestamp).toDate(),
      duration: durationFromMap(map['duration']),
    );
  }
}

/// The type of repeating event. E. g. daily, weekly, monthly, yearly
enum RepeatingEventType {
  daily,
  weekly,
  monthly,
  yearly;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory RepeatingEventType.fromMap(Map<String, dynamic> map) {
    return RepeatingEventType.values.firstWhere(
      (e) => e.toMap() == map,
    );
  }
}

enum EventTypes {
  homework,
  test,
  reminder,
  repeating,
}

enum Difficulty {
  easy(name: "Leicht"),
  medium(name: "Mittel"),
  hard(name: "Schwer");

  final String name;

  const Difficulty({
    required this.name,
  });

  String get englishName {
    switch (this) {
      case Difficulty.easy:
        return "Easy";
      case Difficulty.medium:
        return "Medium";
      case Difficulty.hard:
        return "Hard";
    }
  }
}
