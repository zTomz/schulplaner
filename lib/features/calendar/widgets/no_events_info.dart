import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/constants/svg_pictures.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: kInfoImageSize,
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? SvgPictures.no_data_dark
                    : SvgPictures.no_data_light,
              ),
            ),
            const SizedBox(height: Spacing.medium),
            Text(
              "Keine Ereignisse am ${selectedDate.day}. ${selectedDate.monthString} ${selectedDate.year}",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
