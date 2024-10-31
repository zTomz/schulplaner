import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/widgets/custom/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/events_side_panel.dart';
// import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/event_floating_action_button.dart';

@RoutePage()
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final eventsData = ref.watch(eventsProvider);
    final EventData eventsForDay = eventsData.fold(
      (failure) => [],
      (data) => data.eventsForDay,
    );

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const EventFloatingActionButton(),
      appBar: const CustomAppBar(
        title: Text("Übersicht"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: min(MediaQuery.sizeOf(context).width * 0.4, 400),
              child: EventsSidePanel(
                day: DateTime.now(),
                events: eventsForDay,
              ),
            ),
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
