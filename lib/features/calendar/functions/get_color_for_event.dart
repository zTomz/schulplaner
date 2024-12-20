import 'package:flutter/material.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

Color getColorForEvent(Event event, List<Subject> subjects) {
  switch (event.type) {
    case EventTypes.homework:
      return firstWhereOrNull(
                  subjects,
                  (subject) =>
                      subject.uuid == (event as HomeworkEvent).subjectUuid)
              ?.color ??
          Colors.blue;
    case EventTypes.test:
      return firstWhereOrNull(subjects,
                  (subject) => subject.uuid == (event as TestEvent).subjectUuid)
              ?.color ??
          Colors.blue;
    case EventTypes.reminder:
      return (event as ReminderEvent).color;
    case EventTypes.repeating:
      return (event as RepeatingEvent).color;
    case EventTypes.unimplemented:
      return Colors.red;
  }
}
