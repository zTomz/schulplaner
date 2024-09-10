import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class SnackBarService {
  // TODO: Add an SnackBarService.of(context) method

  static void show({
    required BuildContext context,
    required Widget content,
    CustomSnackbarType type = CustomSnackbarType.normal,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: min(MediaQuery.of(context).size.width, 600),
        content: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    colors: [
                      type.backgroundColor ??
                          Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.medium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (type != CustomSnackbarType.normal) ...[
                    Icon(
                      type.icon,
                      color: type.backgroundColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: Spacing.medium),
                  ],
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    child: Expanded(
                      child: content,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radii.small),
        ),
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

enum CustomSnackbarType {
  info,
  warning,
  error,
  normal;

  IconData? get icon {
    switch (this) {
      case CustomSnackbarType.info:
        return LucideIcons.info;
      case CustomSnackbarType.warning:
        return LucideIcons.circle_alert;
      case CustomSnackbarType.error:
        return LucideIcons.circle_x;
      case CustomSnackbarType.normal:
        return null;
    }
  }

  Color? get backgroundColor {
    switch (this) {
      case CustomSnackbarType.info:
        return const Color(0xFF7695FF);
      case CustomSnackbarType.warning:
        return const Color(0xFFFABC3F);
      case CustomSnackbarType.error:
        return const Color(0xFFFF4C4C);
      case CustomSnackbarType.normal:
        return null;
    }
  }
}
