import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/app_colors.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class CreateTimetablePage extends StatelessWidget {
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
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: AppColors.primaryColor,
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: Container(),
    );
  }
}
