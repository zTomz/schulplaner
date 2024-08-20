import 'package:flutter/material.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/app_colors.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class AccountCreationLayout extends StatelessWidget {
  /// The title of the layout
  final String title;

  /// The description of the layout. Located under the title
  final String description;

  /// The text of the button
  final String buttonText;

  /// The icon of the button
  final Widget buttonIcon;

  /// The function that is called when the button is pressed
  final void Function() onPressed;

  /// Whether the button has a shadow. If this is true, the page will not have a gradient
  final bool buttonHasShadow;

  const AccountCreationLayout({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    this.buttonHasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      color: buttonHasShadow ? Colors.transparent : AppColors.primaryColor,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.2,
      ),
      body: Column(
        children: [
          Text(
            title,
            style: TextStyles.titleLarge,
          ),
          const SizedBox(height: Spacing.medium),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: Text(
              description,
              style: TextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (buttonHasShadow)
                  const BoxShadow(
                    color: AppColors.primaryColor,
                    spreadRadius: 5,
                    blurRadius: 20,
                  ),
              ],
              borderRadius: BorderRadius.circular(180),
            ),
            child: ElevatedButton.icon(
              onPressed: onPressed,
              label: Text(buttonText),
              icon: Padding(
                padding: const EdgeInsets.only(right: Spacing.small),
                child: buttonIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
