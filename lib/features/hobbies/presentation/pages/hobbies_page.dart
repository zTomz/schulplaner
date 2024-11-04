import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_provider.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/widgets/custom/custom_app_bar.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/hobby_floating_action_button.dart';
import 'package:schulplaner/shared/widgets/hobby_list_tile.dart';

@RoutePage()
class HobbiesPage extends ConsumerWidget {
  const HobbiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbiesData = ref.watch(hobbiesProvider);

    return Scaffold(
      floatingActionButton: const HobbyFloatingActionButton(),
      appBar: const CustomAppBar(
        title: Text(
          "Hobbies",
        ),
      ),
      body: hobbiesData.fold(
        (failure) => const DataErrorWidget(),
        (hobbies) {
          if (hobbies.isEmpty) {
            return NoDataWidget(
              addDataButton: ElevatedButton(
                onPressed: () async {
                  final result = await showCustomDialog<Hobby>(
                    context: context,
                    builder: (context) {
                      return const EditHobbyDialog();
                    },
                  );

                  if (result != null) {
                    await ref
                        .read(hobbiesProvider.notifier)
                        .addHobby(hobby: result);
                  }
                },
                child: const Text("Hobby hinzufügen"),
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
                  final result = await showCustomDialog<Hobby>(
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
                  final result = await showCustomDialog<bool>(
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
