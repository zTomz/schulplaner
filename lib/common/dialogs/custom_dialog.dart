import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class CustomDialog extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget content;
  final List<Widget>? actions;

  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radii.medium),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.extraLarge),
          child: SizedBox(
            width: 275,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: Theme.of(context).iconTheme.copyWith(
                        size: 60,
                      ),
                  child: icon,
                ),
                const SizedBox(height: Spacing.large),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.displaySmall!,
                  child: title,
                ),
                const SizedBox(height: Spacing.medium),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!,
                  child: content,
                ),
                const SizedBox(height: Spacing.extraLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ?? [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
