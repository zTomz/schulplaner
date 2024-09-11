import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  /// The body of the scaffold.
  final Widget body;

  /// Optional. The app bar of the scaffold.
  final PreferredSizeWidget? appBar;

  /// Optional. The floating action button of the scaffold.
  final Widget? floatingActionButton;

  final bool withoutGradient;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.withoutGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Container(
            decoration: withoutGradient ? null : BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 0.75,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                if (appBar != null) appBar!,
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
