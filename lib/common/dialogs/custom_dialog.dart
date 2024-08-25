import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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

  CustomDialog.confirmation({
    super.key,
    String? title,
    required String description,
    required void Function() onConfirm,
    required void Function() onCancel,
  })  : icon = const Icon(LucideIcons.badge_alert),
        title = Text(title ?? "Bist du dir sicher?"),
        content = Text(description),
        actions = [
          TextButton(
            onPressed: onCancel,
            child: const Text("Nein"),
          ),
          const SizedBox(width: Spacing.small),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text("Ja"),
          ),
        ];

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
                  textAlign: TextAlign.center,
                  child: title,
                ),
                const SizedBox(height: Spacing.medium),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
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
