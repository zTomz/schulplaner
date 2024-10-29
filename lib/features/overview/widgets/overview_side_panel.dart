import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';

class OverviewSidePanel extends ConsumerWidget {
  const OverviewSidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final eventsData = ref.watch(eventsProvider);

    return Container(
      width: min(MediaQuery.sizeOf(context).width * 0.4, 400),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radii.small),
      ),
    );
  }
}
