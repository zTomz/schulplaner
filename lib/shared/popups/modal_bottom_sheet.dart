import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class ModalBottomSheet extends StatelessWidget {
  final Widget content;
  final Widget? title;
  final String? errorMessage;

  const ModalBottomSheet({
    super.key,
    required this.content,
    this.title,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - Spacing.extraLarge,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.medium,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(Spacing.medium),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(360),
              ),
            ),
          ),
          if (errorMessage != null) ...[
            Text(
              errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.medium),
          ],
          if (title != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w900),
                child: title!,
              ),
            ),
            const SizedBox(height: Spacing.small),
          ],
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: content,
          ),
          const SizedBox(height: Spacing.large),
        ],
      ),
    );
  }
}
