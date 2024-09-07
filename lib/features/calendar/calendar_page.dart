import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/features/calendar/widgets/calendar_view.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const CustomAppBar(
        title: Text("Kalender"),
      ),
      body: SizedBox(
        width: 500,
        child: CalendarView(
          startDate: DateTime.now(),
          onDaySelected: (date) {
            // TODO: Handle select a day in calendar
          },
          events: [
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
            ), Event(
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
          ],
        ),
      ),
    );
  }
}
