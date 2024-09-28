import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/overview/widgets/generate_with_ai_button.dart';

@RoutePage()
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              color: Colors.blue,
            ),
            Expanded(
              child: Center(
                child: GenerateWithAiButton(
                  onGenerate: () {},
                  icon: const Icon(LucideIcons.sparkles),
                  child: const Text("Tagesplan generieren"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
