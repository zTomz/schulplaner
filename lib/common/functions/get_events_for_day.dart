import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/models/event.dart';

/// Get all events for a specific day. Parameters are the day for which the
/// events should be fetched and an list of events.
List<Event> getEventsForDay(
  DateTime day, {
  List<Event> events = const [],
}) {
  return events
      .where(
        (event) => day.compareWithoutTime(
          event.date.date,
          repeatingType: event.repeatingEventType,
        )
            ? event.repeatingEventType != null
                ? day.isAfter(event.date.date) ||
                    day.compareWithoutTime(event.date.date)
                : true
            : false,
      )
      .toList(growable: false);
}
