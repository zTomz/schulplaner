// TODO: Also show hobbies for the selected day

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/functions/get_events_for_day.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/features/calendar/widgets/calendar_view.dart';
import 'package:schulplaner/features/calendar/widgets/event_info_box.dart';
import 'package:schulplaner/features/calendar/widgets/no_events_info.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CalendarPage extends HookWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = useState<DateTime>(DateTime.now());

    final testTeacher = Teacher(
      lastName: "Mustermann",
      gender: Gender.male,
      uuid: const Uuid().v4(),
    );
    final testSubject = Subject(
      name: "Deutsch",
      teacher: testTeacher,
      color: Colors.blue,
      uuid: const Uuid().v4(),
    );
    final List<Event> testEvents = [
      HomeworkEvent(
        description: "The homework for Math",
        color: Colors.blue,
        uuid: const Uuid().v4(),
        date: EventDate(
          date: DateTime.now(),
          duration: const Duration(minutes: 60),
        ),
        subject: testSubject,
      ),
      TestEvent(
        description: "Test Test Test",
        color: Colors.green,
        uuid: const Uuid().v4(),
        deadline: DateTime.now().add(const Duration(days: 5)),
        praticeDates: [
          EventDate(
            date: DateTime.now(),
            duration: const Duration(minutes: 60),
          ),
          EventDate(
            date: DateTime.now().add(const Duration(days: 1)),
            duration: const Duration(minutes: 60),
          ),
          EventDate(
            date: DateTime.now().add(const Duration(days: 2)),
            duration: const Duration(minutes: 60),
          ),
        ],
        subject: testSubject,
      ),
      RepeatingEvent(
        name: "Test",
        description:
            "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test",
        color: Colors.red,
        date: EventDate(
          date: DateTime.now(),
          duration: const Duration(minutes: 60),
        ),
        repeatingEventType: RepeatingEventType.weekly,
        uuid: const Uuid().v4(),
      ),
      FixedEvent(
        name: "Klasenfahrt",
        description: "Klassenfahrt zum  Gardersee",
        place: "Gardersee",
        color: Colors.pink,
        date: EventDate(
          date: DateTime.now().add(const Duration(days: 17)),
          duration: const Duration(minutes: 60),
        ),
        uuid: const Uuid().v4(),
      ),
    ];

    final eventsOfDay = getEventsForDay(
      selectedDate.value,
      events: testEvents,
    );

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
                events: testEvents,
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
                    ? NoEventsInfo(selectedDate: selectedDate.value)
                    : ListView.builder(
                        itemCount: eventsOfDay.length,
                        itemBuilder: (context, index) {
                          final event = eventsOfDay[index];

                          return EventInfoBox(event: event);
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
