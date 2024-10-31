import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/functions/get_events_for_day.dart';
import 'package:schulplaner/shared/widgets/custom/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/features/calendar/presentation/widgets/calendar_view.dart';
import 'package:schulplaner/shared/widgets/events_side_panel.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/event_floating_action_button.dart';

@RoutePage()
class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState<DateTime>(DateTime.now());
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final eventsData = ref.watch(eventsProvider);

    return eventsData.fold(
      (failure) => const DataErrorWidget(),
      (events) {
        final eventsForDay = getEventsForDay(
          selectedDate.value,
          events: events,
        );

        return weeklyScheduleData.fold(
          (failure) => const DataErrorWidget(),
          (weeklyScheduleData) => Scaffold(
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: const EventFloatingActionButton(),
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
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: CalendarView(
                      startDate: DateTime.now(),
                      selectedDate: selectedDate.value,
                      onDaySelected: (date) {
                        selectedDate.value = date;
                      },
                      events: events,
                      subjects: weeklyScheduleData.subjects,
                    ),
                  ),
                  const SizedBox(width: Spacing.medium),
                  Expanded(
                    child: EventsSidePanel(
                      events: eventsForDay,
                      day: selectedDate.value,
                    )
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
