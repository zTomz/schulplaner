import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class CustomDialog extends StatelessWidget {
  /// The icon of the dialog. Displayed at the top
  final Widget icon;

  /// The title of the dialog. Displayed under the icon
  final Widget title;

  /// The content of the dialog. Displayed under the title. If an error is provided.
  /// It is displayed under the error.
  final Widget content;

  /// The actions of the dialog. Displayed at the bottom
  final List<Widget>? actions;

  /// Optional. An error widget wich is displayed under the title and above the content
  final Widget? error;

  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.actions,
    this.error,
  });

  CustomDialog.confirmation({
    super.key,
    String? title,
    required String description,
    required void Function() onConfirm,
    required void Function() onCancel,
    this.error,
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
                if (error != null) ...[
                  const SizedBox(height: Spacing.medium),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    textAlign: TextAlign.center,
                    child: error!,
                  ),
                ],
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
