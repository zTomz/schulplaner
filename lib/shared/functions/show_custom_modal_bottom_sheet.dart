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
