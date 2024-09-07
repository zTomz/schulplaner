import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/models/time.dart';

class CalendarView extends HookWidget {
  final DateTime startDate;

  const CalendarView({
    super.key,
    required this.startDate,
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
              icon: const Icon(LucideIcons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: Spacing.medium),

        // The days header
        Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Weekday.values
                .map((day) => Text(
                      day.name.substring(0, 1),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: Spacing.medium),

        // The cells
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 4 / 5,
            ),
            itemBuilder: (context, index) {
              final day = monthDays[index];

              return Container(
                color: Colors.primaries[index % Colors.primaries.length],
                child: Text(
                  day.day.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            },
            itemCount: monthDays.length,
          ),
        ),
      ],
    );
  }
}
