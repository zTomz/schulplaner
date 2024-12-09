import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/selected_school_time_cell_provider.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/widgets/custom/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/weekly_schedule_floating_action_button.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/weekly_schedule.dart';

@RoutePage()
class WeeklySchedulePage extends ConsumerWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSchoolTimeCell = ref.watch(selectedSchoolTimeCellProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: WeeklyScheduleFloatingActionButton(
        selectedSchoolTimeCell: selectedSchoolTimeCell,
      ),
      appBar: const CustomAppBar(
        title: Text(
          "Stundenplan",
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: WeeklySchedule(),
      ),
    );
  }
}
