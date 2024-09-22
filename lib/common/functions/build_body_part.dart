import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

Widget buildBodyPart({
  required Widget title,
  required Widget child,
  EdgeInsets padding = const EdgeInsets.only(bottom: Spacing.medium),
}) {
  return Builder(
    builder: (context) {
      return Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: title,
            ),
            const SizedBox(height: Spacing.small),
            child,
          ],
        ),
      );
    },
  );
}
