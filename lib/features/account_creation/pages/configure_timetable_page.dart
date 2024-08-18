import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/features/account_creation/pages/create_timetable_page.dart';
import 'package:schulplaner/features/account_creation/widgets/account_creation_layout.dart';

@RoutePage()
class ConfigureTimetablePage extends HookWidget {
  const ConfigureTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return PageView(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        AccountCreationLayout(
          title: "Stundenplan erstellen",
          description:
              "Mithilfe von deinem Stundenplan, kann die App die Ereignisse und Termine so legen, dass sie in dein Zeitfenster passen.",
          buttonText: "Erstellen einen Plan",
          buttonIcon: const Icon(LucideIcons.pencil_ruler),
          onPressed: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
          },
          buttonHasShadow: true,
        ),
        const CreateTimetablePage(),
      ],
    );
  }
}
