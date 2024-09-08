import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';

class NoEventsInfo extends StatelessWidget {
  final DateTime selectedDate;

  const NoEventsInfo({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.large),
        child: Text(
          "Keine Ereignisse am ${selectedDate.day}. ${selectedDate.monthString} ${selectedDate.year}",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
