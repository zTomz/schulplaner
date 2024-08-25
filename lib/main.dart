import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/routes/router.dart';
import 'package:schulplaner/config/theme/app_theme.dart';
import 'package:schulplaner/features/account_creation/widgets/weekly_schedule.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: const WeeklyScheduleTestPage(),
    );

    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: AppTheme.darkTheme,
    );
  }
}

class WeeklyScheduleTestPage extends HookWidget {
  const WeeklyScheduleTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: WeeklySchedule(
          lessons: [
            Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
              weekday: Weekdays.monday,
              subject: Subject(
                subject: "Deutsch",
                teacher: Teacher(
                  firstName: "Mario",
                  lastName: "Schulze",
                  gender: Gender.male,
                  email: "",
                  favorite: false,
                ),
                color: Colors.blue,
              ),
              room: "21",
              uuid: "123",
            ),
             Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
              weekday: Weekdays.monday,
              subject: Subject(
                subject: "Kunst",
                teacher: Teacher(
                  firstName: "Mario",
                  lastName: "Schulze",
                  gender: Gender.male,
                  email: "",
                  favorite: false,
                ),
                color: Colors.blue,
              ),
              room: "21",
              uuid: "123",
            ),
            Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
              weekday: Weekdays.friday,
              subject: Subject(
                subject: "Englisch",
                teacher: Teacher(
                  firstName: "Mario",
                  lastName: "Schulze",
                  gender: Gender.male,
                  email: "",
                  favorite: false,
                ),
                color: Colors.blue,
              ),
              room: "21",
              uuid: "123",
            ),
            Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
              weekday: Weekdays.tuesday,
              subject: Subject(
                subject: "Deutsch",
                teacher: Teacher(
                  firstName: "Mario",
                  lastName: "Schulze",
                  gender: Gender.male,
                  email: "",
                  favorite: false,
                ),
                color: Colors.blue,
              ),
              room: "21",
              uuid: "123",
            ),
          ],
        ),
      ),
    );
  }
}
