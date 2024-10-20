import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/auth/presentation/widgets/account_creation_layout.dart';

@RoutePage()
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountCreationLayout(
      title: "Schulplaner",
      description:
          "Ihr digitaler Schulassistent: Effiziente Planung von Hausaufgaben, Prüfungen und mehr. 🔥",
      buttonText: "Starten",
      buttonIcon: const Icon(LucideIcons.arrow_right),
      onPressed: () {
        context.pushRoute(const ConfigureWeeklyScheduleRoute());
      },
      secondButton: TextButton(
        onPressed: () async {
          await context.router.push(
            SignUpSignInRoute(
              alreadyHasAnAccount: true,
            ),
          );
        },
        child: const Text(
          "Sie haben bereits ein Konto?",
        ),
      ),
      buttonHasShadow: true,
    );
  }
}
