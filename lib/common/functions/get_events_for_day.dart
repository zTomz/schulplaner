import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/models/event.dart';

/// Get all events for a specific day. Parameters are the day for which the
/// events should be fetched and an list of events.
List<Event> getEventsForDay(
  DateTime day, {
  required List<Event> events,
}) {
  return events.where(
    (event) {
      switch (event.type) {
        case EventTypes.homework:
          return day.compareWithoutTime(
            (event as HomeworkEvent).date,
          );
        case EventTypes.test:
          // Add all the practice dates
          for (final date in (event as TestEvent).praticeDates) {
            if (day.compareWithoutTime(date.date)) {
              return true;
            }
          }

          // Add the deadline of the test
          return day.compareWithoutTime(
            event.date,
          );

        case EventTypes.repeating:
          return day.compareWithoutTime(
                    (event as RepeatingEvent).date,
                    repeatingType: event.repeatingEventType,
                  ) &&
                  day.isAfter(event.date) ||
              day.compareWithoutTime(event.date);

        case EventTypes.reminder:
          return day.compareWithoutTime(
            (event as ReminderEvent).date,
          );
      }
    },
  ).toList(growable: false);

  //     return day.compareWithoutTime(
  //     event.date.date,
  //     repeatingType: event.repeatingEventType,
  //   )
  //       ? event.repeatingEventType != null
  //           ? day.isAfter(event.date.date) ||
  //               day.compareWithoutTime(event.date.date)
  //           : true
  //       : false;
  //   },
  // )
  // .toList(growable: false);
}
