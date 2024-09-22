import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';

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

  /// The type of the dialog
  final _CustomDialogType _type;

  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.actions,
    this.error,
  }) : _type = _CustomDialogType.normal;

  /// Returns true or false.
  CustomDialog.confirmation({
    super.key,
    String? title,
    required String description,
    this.error,
  })  : _type = _CustomDialogType.normal,
        icon = const Icon(LucideIcons.badge_alert),
        title = Text(title ?? "Sind Sie sich sicher?"),
        content = Text(description),
        actions = [
          Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  false,
                );
              },
              child: const Text("Nein"),
            );
          }),
          const SizedBox(width: Spacing.small),
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    true,
                  );
                },
                child: const Text("Ja"),
              );
            },
          ),
        ];

  const CustomDialog.expanded({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.actions,
    this.error,
  }) : _type = _CustomDialogType.expanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.medium),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radii.medium),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.extraLarge),
            child: _type == _CustomDialogType.emptyExpanded
                ? title
                : SizedBox(
                    width: _type == _CustomDialogType.normal
                        ? 275
                        : min(MediaQuery.sizeOf(context).width * 0.7, 500),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_type == _CustomDialogType.normal) ...[
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
                          ] else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconTheme(
                                  data: Theme.of(context).iconTheme.copyWith(
                                        size: 40,
                                      ),
                                  child: icon,
                                ),
                                const SizedBox(width: Spacing.large),
                                Expanded(
                                  child: DefaultTextStyle(
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!,
                                    child: title,
                                  ),
                                ),
                              ],
                            ),
                          if (error != null) ...[
                            const SizedBox(height: Spacing.medium),
                            DefaultTextStyle(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                          const SizedBox(height: Spacing.large),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: actions ?? [],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

enum _CustomDialogType {
  normal,
  expanded,
  emptyExpanded;
}
