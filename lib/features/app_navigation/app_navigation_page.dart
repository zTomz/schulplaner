import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/app_navigation/widgets/custom_navigation_rail.dart';

@RoutePage()
class AppNavigationPage extends HookWidget {
  const AppNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationRailIsExtended = useState<bool>(false);

    return AutoTabsRouter(
      routes: const [
        OverviewRoute(),
        WeeklyScheduleRoute(),
        CalendarRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        // the passed child is technically our animated selected-tab page
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          floatingActionButton: FloatingActionButton.large(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Icon(LucideIcons.plus),
          ),
          body: Row(
            children: [
              CustomNavigationRail(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                onProfilePressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AccountDialog(),
                  );
                },
                extended: navigationRailIsExtended.value,
                onExtendedChanged: (isExtended) {
                  navigationRailIsExtended.value = isExtended;
                },
                destinations: const [
                  CustomNavigationDestination(
                    label: "Übersicht",
                    icon: Icon(LucideIcons.panels_top_left),
                  ),
                  CustomNavigationDestination(
                    label: "Stundenplan",
                    icon: Icon(LucideIcons.notebook_tabs),
                  ),
                  CustomNavigationDestination(
                    label: "Kalender",
                    icon: Icon(LucideIcons.calendar),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

class AccountDialog extends HookWidget {
  const AccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = useMemoized(() => FirebaseAuth.instance.currentUser!);

    final usernameController = useTextEditingController(
      text: currentUser.displayName ?? "Unknown",
    );
    final emailController = useTextEditingController(
      text: currentUser.email,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Form(
      key: formKey,
      child: CustomDialog.expanded(
        closeOnOutsideTap: false,
        icon: const Icon(LucideIcons.user),
        title: CustomTextField(
          controller: usernameController,
          labelText: "Username",
          autovalidateMode: AutovalidateMode.always,
          validate: true,
          validator: (value) {
            if (value == null || value.trim().length < 3) {
              return "Der Name muss mindestens 3 Zeichen lang sein.";
            }

            return null;
          },
          keyboardType: TextInputType.name,
        ),
        content: Column(
          children: [
            buildBodyPart(
              title: const Text("Email"),
              child: CustomTextField(
                controller: emailController,
                hintText: "Email",
                autovalidateMode: AutovalidateMode.always,
                validate: true,
                validator: (value) {
                  if (value == null ||
                      !value.contains("@") ||
                      !value.contains(".") ||
                      value.endsWith(".")) {
                    return "Bitte gib eine gültige Email Adresse ein.";
                  }

                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // TODO: Delete account
                    await FirebaseAuth.instance.currentUser!.delete();
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  icon: const Icon(LucideIcons.user_round_x),
                  label: const Text("Account löschen"),
                ),
                const SizedBox(width: Spacing.small),
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  icon: const Icon(LucideIcons.log_out),
                  label: const Text("Abmelden"),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await currentUser.updateDisplayName(
                  usernameController.text.trim(),
                );
                await currentUser.updateEmail(
                  emailController.text.trim(),
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text("Schließen"),
          ),
        ],
      ),
    );
  }
}
