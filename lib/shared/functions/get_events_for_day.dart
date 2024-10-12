import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/models/event.dart';

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
          // Add the processing date
          if (day.compareWithoutTime((event as HomeworkEvent).processingDate.date)) {
            return true;
          }

          return day.compareWithoutTime(
            event.date,
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
                    event.date,
                    repeatingType: (event as RepeatingEvent).repeatingEventType,
                  ) &&
                  day.isAfter(event.date) ||
              day.compareWithoutTime(event.date);

        case EventTypes.reminder:
          return day.compareWithoutTime(
            event.date,
          );
      }
    },
  ).toList(growable: false);
}
