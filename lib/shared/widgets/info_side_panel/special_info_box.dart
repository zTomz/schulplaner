import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

/// A small box, to display special information about an event. For example
/// its place
class SpecialInfoBox extends StatelessWidget {
  /// A icon that is displayed before the text
  final Widget icon;

  /// A widget, containing the text
  final Widget text;

  const SpecialInfoBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          IconTheme(
            data: IconThemeData(
              color: Theme.of(context).colorScheme.outline,
              size: 12,
            ),
            child: icon,
          ),
          const SizedBox(width: Spacing.small),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            child: text,
          ),
        ],
      ),
    );
  }
}
