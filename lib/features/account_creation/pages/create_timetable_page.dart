import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class CreateTimetablePage extends HookWidget {
  const CreateTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          "Stundenplan erstellen",
          style: TextStyles.title,
        ),
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: const Text("Fach hinzufügen"),
          ),
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.pushRoute(const ConfigureHobbyRoute());
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
