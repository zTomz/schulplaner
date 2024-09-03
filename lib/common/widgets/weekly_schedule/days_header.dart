import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';

import 'models.dart';

/// The header of the weekly schedule. Shows the day and it's date. As well as the current
/// week
class WeeklyScheduleDaysHeader extends StatelessWidget {
  final void Function() onWeekTapped;
  final double timeColumnWidth;
  final Week week;

  const WeeklyScheduleDaysHeader({
    super.key,
    required this.onWeekTapped,
    required this.timeColumnWidth,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: timeColumnWidth,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => onWeekTapped(),
                borderRadius: const BorderRadius.vertical(top: Radii.small),
                child: Center(
                  child: Text(
                    week.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Spacing.small),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(top: Radii.small),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _getWeekdays()
                    .map(
                      (day) => Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(Spacing.small),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: DateTime.now().weekday == day.weekday
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                              child: Text(
                                _getWeekdayName(day).substring(0, 1),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color:
                                          DateTime.now().weekday == day.weekday
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                      height: 1,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              day.day.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gets the weekdays of the current week. From Monday to Friday
  List<DateTime> _getWeekdays() {
    final monday = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    return [
      monday,
      monday.add(const Duration(days: 1)),
      monday.add(const Duration(days: 2)),
      monday.add(const Duration(days: 3)),
      monday.add(const Duration(days: 4)),
    ];
  }

  /// Gets the name of the weekday. Based on the DateTime input
  String _getWeekdayName(DateTime weekday) {
    switch (weekday.weekday) {
      case 1:
        return "Montag";
      case 2:
        return "Dienstag";
      case 3:
        return "Mittwoch";
      case 4:
        return "Donnerstag";
      case 5:
        return "Freitag";
      case 6:
        return "Samstag";
      case 7:
        return "Sonntag";
      default:
        return "";
    }
  }
}
