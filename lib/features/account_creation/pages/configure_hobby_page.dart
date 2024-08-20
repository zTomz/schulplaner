import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/features/account_creation/widgets/account_creation_layout.dart';

@RoutePage()
class ConfigureHobbyPage extends StatelessWidget {
  const ConfigureHobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountCreationLayout(
      title: "Hast du ein Hobby?",
      description:
          "Wenn du uns dein Hobby mitteilst, kann dir die App Ereignisse und Termine so legen, dass sie in dein Zeitfenster passen.",
      buttonText: "Füge dein Hobby hinzu",
      buttonIcon: const Icon(LucideIcons.arrow_right),
      onPressed: () {},
      secondButton: TextButton(
        onPressed: () {},
        child: Text(
          "Ich habe keine Hobbies",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceContainer,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
