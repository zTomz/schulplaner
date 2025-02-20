import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/features/calendar/functions/get_color_for_event.dart';

class CalendarView extends HookWidget {
  final DateTime startDate;
  final DateTime selectedDate;
  final EventData events;
  final List<Subject> subjects;
  final void Function(DateTime date) onDaySelected;

  const CalendarView({
    super.key,
    required this.startDate,
    required this.selectedDate,
    required this.events,
    required this.subjects,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = useState<DateTime>(startDate);
    final calendarViewController = usePageController(
      initialPage: 1,
    );

    return Column(
      children: [
        // The header of the calendar view
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                await calendarViewController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linearToEaseOut,
                );
              },
              tooltip: "Vorheriger Monat",
              icon: const Icon(LucideIcons.chevron_left),
            ),
            TextButton(
              onPressed: () async {
                final DateTime? result = await showDatePicker(
                  context: context,
                  initialDate: currentMonth.value,
                  firstDate: DateTime.utc(2008),
                  lastDate: DateTime.utc(2055),
                );

                if (result != null) {
                  currentMonth.value = result;
                }
              },
              child: Text(
                "${currentMonth.value.monthString} - ${currentMonth.value.year}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              onPressed: () async {
                await calendarViewController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linearToEaseOut,
                );
              },
              tooltip: "Nächster Monat",
              icon: const Icon(LucideIcons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: Spacing.medium),

        // The days header
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radii.small),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Weekday.values
                .map(
                  (day) => Text(
                    day.name.substring(0, 1),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: Spacing.medium),

        // The cells
        Expanded(
          child: PageView.builder(
            controller: calendarViewController,
            onPageChanged: (value) {
              // Go to next month
              currentMonth.value = currentMonth.value.copyWith(
                month: currentMonth.value.month - 1 + value,
              );

              // Jump to middle page
              calendarViewController.jumpToPage(1);
            },
            itemCount: 3,
            itemBuilder: (context, index) => CalendarWidget(
              currentMonth: currentMonth.value.copyWith(
                month: currentMonth.value.month - 1 + index,
              ),
              selectedDate: selectedDate,
              events: events,
              subjects: subjects,
              onDaySelected: onDaySelected,
            ),
          ),
        ),
      ],
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<Event> events;
  final List<Subject> subjects;
  final void Function(DateTime date) onDaySelected;

  const CalendarWidget({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.events,
    required this.subjects,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthDays = currentMonth.datesOfMonths();

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              // Divide the width by 7 because of 7 days in a week and the height by 6 because of max. 6 weeks per month
              childAspectRatio:
                  (constraints.maxWidth / 7) / (constraints.maxHeight / 6),
            ),
            itemBuilder: (context, index) {
              final day = monthDays[index];
              final dayIsSelected = day.compareWithoutTime(selectedDate);
              final eventsOfDay = events.getEventsForDay(day);

              return MaterialButton(
                onPressed: () {
                  onDaySelected(day);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.small),
                ),
                padding: const EdgeInsets.all(Spacing.extraSmall),
                child: Column(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: day.compareWithoutTime(DateTime.now())
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        color: dayIsSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: dayIsSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : day.month != currentMonth.month
                                      ? Theme.of(context).colorScheme.outline
                                      : day.compareWithoutTime(DateTime.now())
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Spacing.small),
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      spacing: 4,
                      runSpacing: 8,
                      children: [
                        for (int i = 0; i < min(8, eventsOfDay.length); i++)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // If the date is not the current day, we have a processing date. Which we want to display in a lighter color.
                              color: eventsOfDay[i].date.compareWithoutTime(day)
                                  ? getColorForEvent(
                                      eventsOfDay[i],
                                      subjects,
                                    )
                                  : getColorForEvent(
                                      eventsOfDay[i],
                                      subjects,
                                    ).withOpacity(0.6),
                            ),
                          ),
                        if (eventsOfDay.length - 8 > 0)
                          Text(
                            "+${eventsOfDay.length - 8}",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      height: 1,
                                    ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: monthDays.length,
          );
        },
      ),
    );
  }
}
