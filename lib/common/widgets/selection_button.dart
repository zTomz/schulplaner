import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class SelectionButton extends StatelessWidget {
  final void Function()? onPressed;

  final String title;
  final String? selection;

  const SelectionButton({
    super.key,
    this.onPressed,
    required this.title,
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => onPressed?.call(),
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              title,
            ),
            const Spacer(),
            if (selection != null) ...[
              Text(selection!),
              const SizedBox(width: Spacing.medium),
            ],
            const Icon(LucideIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}
