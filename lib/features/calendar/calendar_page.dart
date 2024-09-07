import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/features/calendar/widgets/calendar_view.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CalendarPage extends HookWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = useState<DateTime>(DateTime.now());

    final List<Event> events = [
      Event(
        name: "Test",
        description:
            "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        repeatingEventType: RepeatingEventType.weekly,
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Another test",
        color: Colors.lightBlue,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 180),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Another test",
        color: Colors.lightBlue,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 180),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Another test",
        color: Colors.lightBlue,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 180),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Another test",
        color: Colors.lightBlue,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 180),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Another test",
        color: Colors.lightBlue,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 180),
        ),
        uuid: const Uuid().v4(),
      ),
      Event(
        name: "Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 5)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
    ];

    final eventsOfDay = events
        .where(
          (event) => selectedDate.value.compareWithoutTime(
            event.date.date,
            repeatingType: event.repeatingEventType,
          ),
        )
        .toList(growable: false);

    return GradientScaffold(
      appBar: const CustomAppBar(
        title: Text("Kalender"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Spacing.medium,
          right: Spacing.medium,
          bottom: Spacing.medium,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 450,
              child: CalendarView(
                startDate: DateTime.now(),
                selectedDate: selectedDate.value,
                onDaySelected: (date) {
                  selectedDate.value = date;
                },
                events: events,
              ),
            ),
            const SizedBox(width: Spacing.medium),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(Spacing.medium),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(
                        kDefaultOpacity,
                      ),
                  borderRadius: const BorderRadius.all(Radii.medium),
                ),
                child: eventsOfDay.isEmpty
                    ? Center(
                        child: Text(
                          "Keine Ereignisse am ${selectedDate.value.day}. ${selectedDate.value.monthString} ${selectedDate.value.year}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : ListView.builder(
                        itemCount: eventsOfDay.length,
                        itemBuilder: (context, index) {
                          final event = eventsOfDay[index];

                          return Padding(
                            padding: const EdgeInsets.all(Spacing.small),
                            child: MaterialButton(
                              onPressed: () {
                                // TODO: Edit an event
                              },
                              padding: const EdgeInsets.all(Spacing.medium),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radii.small),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: event.color,
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.medium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        if (event.description != null) ...[
                                          const SizedBox(height: Spacing.small),
                                          Text(
                                            event.description!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
