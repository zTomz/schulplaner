import 'package:flutter/material.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';
import 'package:schulplaner/features/account_creation/widgets/gradient_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.2,
      ),
      body: Column(
        children: [
          const Text(
            "Schulplaner",
            style: TextStyles.titleLarge,
          ),
          const SizedBox(height: Spacing.medium),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: const Text(
              "Bringe Schule und Hobby unter einen Hut ohne auf etwas verzichten  zu müssen, nur mithilfe des Zeitmanagements und KI.",
              style: TextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          GradientButton.outlined(
            onTap: () {},
            icon: const Icon(Icons.arrow_forward_rounded),
            child: const Text(
              "Lass uns loslegen",
            ),
          ),
        ],
      ),
    );
  }
}
