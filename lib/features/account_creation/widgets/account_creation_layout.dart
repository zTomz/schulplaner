import 'package:flutter/material.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class AccountCreationLayout extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Widget buttonIcon;
  final void Function() onPressed;

  const AccountCreationLayout({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
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
          ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 16,
              ),
            ),
            label: Text(buttonText),
            icon: Padding(
              padding: const EdgeInsets.only(right: Spacing.small),
              child: buttonIcon,
            ),
          ),
        ],
      ),
    );
  }
}
