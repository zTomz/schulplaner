import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';

Widget buildBodyPart({
  required Widget title,
  required Widget child,
  EdgeInsets padding = const EdgeInsets.all(Spacing.medium),
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
