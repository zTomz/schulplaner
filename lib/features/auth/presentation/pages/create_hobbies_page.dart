import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/svg_pictures.dart';
import 'package:schulplaner/features/auth/presentation/providers/create_hobbies_provider.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/widgets/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/gradient_scaffold.dart';
import 'package:schulplaner/shared/widgets/hobby_list_tile.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class CreateHobbiesPage extends HookConsumerWidget {
  const CreateHobbiesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbies = ref.watch(createHobbiesProvider);

    return GradientScaffold(
      appBar: CustomAppBar(
        title: const Text(
          "Hobbies hinzufügen",
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<Hobby>(
                context: context,
                builder: (context) {
                  return const EditHobbyDialog();
                },
              );

              if (result != null) {
                ref.read(createHobbiesProvider.notifier).addHobby(result);
              }
            },
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
        onPressed: () async {
          await context.router.push(
            SignUpSignInRoute(),
          );
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: hobbies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: kInfoImageSize,
                    child: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? SvgPictures.no_data_dark
                          : SvgPictures.no_data_light,
                    ),
                  ),
                  const SizedBox(height: Spacing.medium),
                  SizedBox(
                    width: kInfoTextWidth,
                    child: Text(
                      "Sie haben noch keine Hobbies hinzugefügt. Beginnen Sie indem Sie ein  \"Hobby hizufügen\".",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: hobbies.length,
              itemBuilder: (context, index) {
                final hobby = hobbies[index];

                return HobbyListTile(
                  hobby: hobby,
                  onEdit: () async {
                    final result = await showDialog<Hobby>(
                      context: context,
                      builder: (context) {
                        return EditHobbyDialog(
                          hobby: hobby,
                        );
                      },
                    );

                    if (result != null) {
                      ref.read(createHobbiesProvider.notifier).editHobby(
                            result,
                          );
                    }
                  },
                  onDelete: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => CustomDialog.confirmation(
                        description:
                            "Sind Sie sich sicher, dass Sie das Hobby \"${hobby.name}\" löschen möchten.",
                      ),
                    );

                    if (result == true) {
                      //  Delete the hobby
                      ref
                          .read(createHobbiesProvider.notifier)
                          .deleteHobby(hobby);
                    }
                  },
                );
              },
            ),
    );
  }
}
