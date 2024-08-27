import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

Widget buildBodyPart(
  BuildContext context, {
  required String title,
  required Widget child,
  EdgeInsets padding = const EdgeInsets.all(Spacing.medium),
}) {
  return Padding(
    padding: padding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: Spacing.small),
        child,
      ],
    ),
  );
}
