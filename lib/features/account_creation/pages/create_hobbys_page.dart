import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class CreateHobbysPage extends HookWidget {
  const CreateHobbysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Hobbys hinzufügen",
          style: TextStyles.title,
        ),
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {},
            icon: const Icon(
              LucideIcons.circle_plus,
              size: 20,
            ),
            label: const Text("Hobby hinzufügen"),
          ),
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // TODO: Go to the next page
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.small,
              horizontal: Spacing.medium,
            ),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radii.small),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: 80,
                child: InkWell(
                  onTap: () {
                    // TODO: Edit the hpbby
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        color: Colors.blue, // TODO: Add the hobby color
                      ),
                      const SizedBox(width: Spacing.medium),
                      Text(
                        "Handball",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // TODO: Edit the hpbby
                        },
                        tooltip: "Hobby bearbeiten",
                        icon: const Icon(LucideIcons.pencil),
                      ),
                      const SizedBox(width: Spacing.medium),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
