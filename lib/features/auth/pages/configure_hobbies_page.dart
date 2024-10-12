import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/auth/presentation/pages/create_hobbies_page.dart';
import 'package:schulplaner/features/auth/widgets/account_creation_layout.dart';

@RoutePage()
class ConfigureHobbyPage extends HookWidget {
  const ConfigureHobbyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return PageView(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        AccountCreationLayout(
          title: "Haben Sie ein Hobby?",
          description:
              "Wenn Sie uns Ihre Hobbies mitteilen, kann Ihnen die App Ereignisse und Termine so legen, dass sie in Ihr Zeitfenster passen.",
          buttonText: "Fügen Sie Ihre Hobbies hinzu",
          buttonIcon: const Icon(LucideIcons.arrow_right),
          onPressed: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
          },
          secondButton: TextButton(
            onPressed: () async {
              await context.router.push(
                SignUpSignInRoute(),
              );
            },
            child: const Text(
              "Sie möchten Ihre Hobbies später hinzufügen?",
            ),
          ),
          buttonHasShadow: true,
        ),
        const CreateHobbiesPage(),
      ],
    );
  }
}
