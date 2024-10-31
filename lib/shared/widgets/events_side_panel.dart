import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/calendar/presentation/widgets/no_events_info.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/widgets/event_info_box.dart';

class EventsSidePanel extends StatelessWidget {
  final DateTime day;
  final List<Event> events;

  const EventsSidePanel({
    super.key,
    required this.day,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.medium),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radii.medium),
      ),
      child: events.isEmpty
          ? NoEventsInfo(selectedDate: day)
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return EventInfoBox(
                  event: event,
                  day: day,
                );
              },
            ),
    );
  }
}
