import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:schulplaner/config/theme/app_colors.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

// TODO: Maybe animate in the future

class GradientButton extends StatelessWidget {
  /// The widget that is displayed inside the button.
  final Widget child;

  /// A function that is called when the button is pressed.
  final void Function() onTap;

  /// An optional widget that is displayed inside the button.
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.icon,
  }) : _variant = _GradientButtonVariant.filled;

  const GradientButton.outlined({
    super.key,
    required this.onTap,
    required this.child,
    this.icon,
  }) : _variant = _GradientButtonVariant.outlined;

  final _GradientButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundColor,
              AppColors.primaryColor,
            ],
          ),
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radii.medium),
        gradient: _variant == _GradientButtonVariant.filled
            ? const LinearGradient(
                colors: [
                  AppColors.backgroundColor,
                  AppColors.primaryColor,
                ],
              )
            : null,
      ),
      child: MaterialButton(
        onPressed: onTap,
        splashColor: AppColors.primaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
             padding: const EdgeInsets.all(Spacing.medium),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radii.medium),
        ),
        child: DefaultTextStyle(
          style: TextStyles.body,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              if (icon != null) ...[
                const SizedBox(width: Spacing.small),
                icon!,
              ]
            ],
          ),
        ),
      ),
    );
  }
}

enum _GradientButtonVariant {
  outlined,
  filled;
}
