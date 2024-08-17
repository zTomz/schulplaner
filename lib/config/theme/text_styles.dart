import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/app_colors.dart';

abstract class TextStyles {
  static const TextStyle titleLarge = TextStyle(
    color: AppColors.foregroundColor,
    fontSize: 70,
  );

  static const TextStyle title = TextStyle(
    color: AppColors.foregroundColor,
    fontSize: 50,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.foregroundColor,
    fontSize: 24,
  );
}
