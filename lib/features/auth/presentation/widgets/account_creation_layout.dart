import 'package:flutter/material.dart';
import 'package:schulplaner/shared/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/app_colors.dart';
import 'package:schulplaner/config/constants/numbers.dart';

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

  /// Optional button that is placed under the primary button.
  final Widget? secondButton;

  const AccountCreationLayout({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    this.secondButton,
    this.buttonHasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      withoutGradient: buttonHasShadow,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.2,
        ),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Spacing.medium),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
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
            if (secondButton != null) ...[
              SizedBox(
                height: buttonHasShadow ? Spacing.large : Spacing.small,
              ),
              secondButton!,
            ],
          ],
        ),
      ),
    );
  }
}
