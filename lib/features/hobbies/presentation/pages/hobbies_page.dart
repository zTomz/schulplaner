import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_provider.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/config/constants/svg_pictures.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/widgets/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/hobby_list_tile.dart';

@RoutePage()
class HobbiesPage extends ConsumerWidget {
  const HobbiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbiesData = ref.watch(hobbiesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text(
          "Hobbies",
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
                ref.read(hobbiesProvider.notifier).addHobby(hobby: result);
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
      body: hobbiesData.fold(
        (failure) => const DataErrorWidget(),
        (hobbies) {
          if (hobbies.isEmpty) {
            return Center(
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
                      "Sie haben noch keine Hobbies hinzugefügt. Beginnen Sie indem Sie ein \"Hobby hizufügen\".",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, index) {
              final currentHobby = hobbies[index];

              return HobbyListTile(
                hobby: currentHobby,
                onEdit: () async {
                  final result = await showDialog<Hobby>(
                    context: context,
                    builder: (context) {
                      return EditHobbyDialog(
                        hobby: currentHobby,
                      );
                    },
                  );

                  if (result != null) {
                    ref.read(hobbiesProvider.notifier).editHobby(hobby: result);
                  }
                },
                onDelete: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => CustomDialog.confirmation(
                      description:
                          "Sind Sie sich sicher, dass Sie das Hobby \"${currentHobby.name}\" löschen möchten.",
                    ),
                  );

                  if (result == true) {
                    ref
                        .read(hobbiesProvider.notifier)
                        .deleteHobby(hobby: currentHobby);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
