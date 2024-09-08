import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/functions/get_events_for_day.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/time.dart';

class CalendarView extends HookWidget {
  final DateTime startDate;
  final DateTime selectedDate;
  final List<Event> events;
  final void Function(DateTime date) onDaySelected;

  const CalendarView({
    super.key,
    required this.startDate,
    required this.selectedDate,
    required this.onDaySelected,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = useState<DateTime>(startDate);

    final monthDays = currentMonth.value.datesOfMonths();

    return Column(
      children: [
        // The header of the calendar view
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Go to previous month
                currentMonth.value = currentMonth.value
                    .copyWith(month: currentMonth.value.month - 1);
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
              onPressed: () {
                // Go to next month
                currentMonth.value = currentMonth.value
                    .copyWith(month: currentMonth.value.month + 1);
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 9 / 10,
              ),
              itemBuilder: (context, index) {
                final day = monthDays[index];
                final dayIsSelected = day.compareWithoutTime(selectedDate);
                final eventsOfDay = getEventsForDay(day, events: events);

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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: dayIsSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : day.month != currentMonth.value.month
                                        ? Theme.of(context).colorScheme.outline
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
                                color: eventsOfDay[i].color,
                              ),
                            ),
                          if (eventsOfDay.length - 8 > 0)
                            Text(
                              "+${eventsOfDay.length - 8}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
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
            ),
          ),
        ),
      ],
    );
  }
}
