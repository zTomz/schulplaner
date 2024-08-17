import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  /// The body of the scaffold.
  final Widget body;

  /// Optional. The color of the gradient. Default is [AppColors.primaryColor].
  final Color? color;

  /// Optional. The padding of the scaffold. Default is [EdgeInsets.zero].
  final EdgeInsets? padding;

  const GradientScaffold({
    super.key,
    required this.body,
    this.color = AppColors.primaryColor,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 0.75,
                colors: [
                  color!,
                  AppColors.backgroundColor,
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: padding!,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
