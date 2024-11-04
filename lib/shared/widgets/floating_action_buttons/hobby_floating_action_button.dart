import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_provider.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/popups/hobby/edit_hobby_dialog.dart';

class HobbyFloatingActionButton extends ConsumerWidget {
  const HobbyFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.large(
      onPressed: () async {
        final result = await showCustomDialog<Hobby>(
          context: context,
          builder: (context) {
            return const EditHobbyDialog();
          },
        );

        if (result != null) {
          await ref.read(hobbiesProvider.notifier).addHobby(hobby: result);
        }
      },
      child: const Icon(LucideIcons.plus),
    );
  }
}
