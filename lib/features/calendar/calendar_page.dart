import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/common/functions/get_events_for_day.dart';
import 'package:schulplaner/common/provider/events_provider.dart';
import 'package:schulplaner/common/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/data_state_widgets.dart';
import 'package:schulplaner/features/calendar/widgets/calendar_view.dart';
import 'package:schulplaner/features/calendar/widgets/event_info_box.dart';
import 'package:schulplaner/features/calendar/widgets/no_events_info.dart';

@RoutePage()
class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState<DateTime>(DateTime.now());
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final eventsData = ref.watch(eventsProvider);

    // final testTeacher = Teacher(
    //   lastName: "Mustermann",
    //   gender: Gender.male,
    //   uuid: const Uuid().v4(),
    // );
    // final testSubject = Subject(
    //   name: "Deutsch",
    //   teacherUuid: testTeacher.uuid,
    //   color: Colors.blue,
    //   uuid: const Uuid().v4(),
    // );
    // final List<Event> testEvents = [
    //   HomeworkEvent(
    //     name: "Hausaufgabe Math",
    //     description: "The homework for Math",
    //     uuid: const Uuid().v4(),
    //     date: EventDate(
    //       date: DateTime.now(),
    //       duration: const Duration(minutes: 60),
    //     ),
    //     subjectUuid: testSubject.uuid,
    //   ),
    //   TestEvent(
    //     name: "Test Math",
    //     description: "Test Test Test",
    //     uuid: const Uuid().v4(),
    //     deadline: DateTime.now().add(const Duration(days: 5)),
    //     praticeDates: [
    //       EventDate(
    //         date: DateTime.now(),
    //         duration: const Duration(minutes: 60),
    //       ),
    //       EventDate(
    //         date: DateTime.now().add(const Duration(days: 1)),
    //         duration: const Duration(minutes: 60),
    //       ),
    //       EventDate(
    //         date: DateTime.now().add(const Duration(days: 2)),
    //         duration: const Duration(minutes: 60),
    //       ),
    //     ],
    //     subjectUuid: testSubject.uuid,
    //   ),
    //   RepeatingEvent(
    //     name: "Test",
    //     description:
    //         "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test",
    //     date: EventDate(
    //       date: DateTime.now(),
    //       duration: const Duration(minutes: 60),
    //     ),
    //     color: Colors.redAccent,
    //     repeatingEventType: RepeatingEventType.weekly,
    //     uuid: const Uuid().v4(),
    //   ),
    //   ReminderEvent(
    //     name: "Klasenfahrt",
    //     description: "Klassenfahrt zum  Gardersee",
    //     color: Colors.blue,
    //     place: "Gardersee",
    //     date: EventDate(
    //       date: DateTime.now().add(const Duration(days: 17)),
    //       duration: const Duration(minutes: 60),
    //     ),
    //     uuid: const Uuid().v4(),
    //   ),
    // ];

    return eventsData.when(
      data: (events) {
        final combinedEvents = [
          ...events.$1,
          ...events.$2,
          ...events.$3,
          ...events.$4,
        ];

        final eventsForDay = getEventsForDay(
          selectedDate.value,
          events: combinedEvents,
        );

        return weeklyScheduleData.when(
          data: (weeklyScheduleData) => Scaffold(
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
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: CalendarView(
                      startDate: DateTime.now(),
                      selectedDate: selectedDate.value,
                      onDaySelected: (date) {
                        selectedDate.value = date;
                      },
                      events: combinedEvents,
                      subjects: weeklyScheduleData.$4,
                    ),
                  ),
                  const SizedBox(width: Spacing.medium),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.medium),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.all(Radii.medium),
                      ),
                      child: eventsForDay.isEmpty
                          ? NoEventsInfo(selectedDate: selectedDate.value)
                          : ListView.builder(
                              itemCount: eventsForDay.length,
                              itemBuilder: (context, index) {
                                final event = eventsForDay[index];

                                return EventInfoBox(
                                  event: event,
                                  day: selectedDate.value,
                                  events: combinedEvents,
                                  subjects: weeklyScheduleData.$4,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (_, __) => const DataErrorWidget(),
          loading: () => const DataLoadingWidget(),
        );
      },
      error: (_, __) {
        return const DataErrorWidget();
      },
      loading: () => const DataLoadingWidget(),
    );
  }
}
