import 'package:flutter/material.dart';

/// A helper function, which has some pre configurations for the [showModalBottomSheet]
/// function.
Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showModalBottomSheet(
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      context: context,
      builder: builder,
    );

/// A helper function, which has some pre configurations for the [showDialog]
/// function.
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showDialog(
      context: context,
      builder: builder,
      barrierDismissible: false,
    );
