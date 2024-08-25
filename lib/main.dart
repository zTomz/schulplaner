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
        padding: const EdgeInsets.all(24),
        child: WeeklySchedule(
          timeSpans: {
            const TimeSpan(
              from: TimeOfDay(hour: 7, minute: 30),
              to: TimeOfDay(hour: 9, minute: 0),
            ),
            const TimeSpan(
              from: TimeOfDay(hour: 9, minute: 20),
              to: TimeOfDay(hour: 10, minute: 50),
            ),
            const TimeSpan(
              from: TimeOfDay(hour: 11, minute: 5),
              to: TimeOfDay(hour: 11, minute: 50),
            ),
            const TimeSpan(
              from: TimeOfDay(hour: 12, minute: 0),
              to: TimeOfDay(hour: 12, minute: 45),
            ),
          },
          lessons: [
            Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 7, minute: 30),
                to: TimeOfDay(hour: 9, minute: 0),
              ),
              weekday: Weekdays.monday,
              week: Week.a,
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
              week: Week.b,
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
                color: Colors.pink[50]!,
              ),
              room: "21",
              uuid: "123",
            ),
            Lesson(
              timeSpan: const TimeSpan(
                from: TimeOfDay(hour: 12, minute: 00),
                to: TimeOfDay(hour: 12, minute: 45),
              ),
              weekday: Weekdays.monday,
              week: Week.all,
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
              week: Week.all,
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
              week: Week.all,
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
          week: Week.b,
        ),
      ),
    );
  }
}
