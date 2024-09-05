import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/features/calendar/widgets/calendar_view.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const CustomAppBar(
        title: Text("Kalender"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: CalendarView(
          startDate: DateTime.now(),
        ),
      ),
    );
  }
}
