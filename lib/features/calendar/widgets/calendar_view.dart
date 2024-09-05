import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';

class CalendarView extends HookWidget {
  final DateTime startDate;

  const CalendarView({
    super.key,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = useState<DateTime>(startDate);

    return Column(
      children: [
        // The header of the calendar view
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
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
                // TODO: Go to next month
                currentMonth.value = currentMonth.value
                    .copyWith(month: currentMonth.value.month + 1);
              },
              icon: const Icon(LucideIcons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
