import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/account_creation/models/create_weekly_schedule_data.dart';
import 'package:schulplaner/features/account_creation/pages/create_hobbies_page.dart';
import 'package:schulplaner/features/account_creation/widgets/account_creation_layout.dart';

@RoutePage()
class ConfigureHobbyPage extends HookWidget {
  final CreateWeeklyScheduleData? createWeeklyScheduleData;

  const ConfigureHobbyPage({
    super.key,
    this.createWeeklyScheduleData,
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
          title: "Hast du ein Hobby?",
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
                SignUpSignInRoute(
                  createWeeklyScheduleData: createWeeklyScheduleData,
                  hobbies: null,
                ),
              );
            },
            child: const Text(
              "Sie möchten Ihre Hobbies später hinzufügen?",
            ),
          ),
          buttonHasShadow: true,
        ),
        CreateHobbiesPage(
          createWeeklyScheduleData: createWeeklyScheduleData,
        ),
      ],
    );
  }
}
