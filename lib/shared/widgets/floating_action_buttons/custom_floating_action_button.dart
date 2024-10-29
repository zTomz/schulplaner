import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final List<Widget> children;
  final GlobalKey<ExpandableFabState> expandebleFabKey;

  const CustomFloatingActionButton({
    super.key,
    required this.expandebleFabKey,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: expandebleFabKey,
      type: ExpandableFabType.up,
      distance: 75,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        blur: 1,
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(LucideIcons.plus),
        fabSize: ExpandableFabSize.large,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(LucideIcons.x),
        fabSize: ExpandableFabSize.regular,
      ),
      children: children,
    );
  }
}

class CustomFabOption extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final void Function()? onPressed;

  const CustomFabOption({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge ?? const TextStyle(),
          child: title,
        ),
        const SizedBox(width: Spacing.medium),
        FloatingActionButton.small(
          heroTag: null,
          onPressed: onPressed,
          foregroundColor: onPressed == null
              ? Theme.of(context).colorScheme.outlineVariant
              : null,
          child: icon,
        ),
      ],
    );
  }
}
