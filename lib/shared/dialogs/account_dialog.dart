import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/exeptions/auth_exeptions.dart';
import 'package:schulplaner/shared/functions/close_all_dialogs.dart';
import 'package:schulplaner/shared/services/exeption_handler_service.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/services/user_service.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';

/// Shows the [AccountDialog].
class AccountDialog extends HookWidget {
  const AccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = useMemoized(() => FirebaseAuth.instance.currentUser!);
    final requiresRecentLoginExeptionThrown = useState(false);

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
        icon: const Icon(LucideIcons.user),
        title: CustomTextField(
          controller: usernameController,
          labelText: "Name",
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
        error: requiresRecentLoginExeptionThrown.value
            ? const Text(
                "Sie müssen sich erneut Anmelden, da die von Ihnen ausgefürhte Aktion einen neuen Login benötigt.")
            : null,
        content: Column(
          children: [
            CustomTextField.email(
              controller: emailController,
              labelText: "Email",
              autovalidateMode: AutovalidateMode.always,
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            CustomButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return const ChangePasswordDialog();
                  },
                );
              },
              child: const Text("Passwort ändern"),
            ),
            const SizedBox(height: Spacing.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => CustomDialog.confirmation(
                        title: "Konto löschen",
                        description:
                            "Sind Sie sich sicher, dass Sie Ihr Konto löschen möchten?",
                      ),
                    );

                    if (result == true) {
                      try {
                        await UserService.deleteAccount();
                      } catch (error) {
                        // If the error is, that the user requires a recent login, we want to only show
                        // a simple error message at the top of the dialog
                        if (error is FirebaseAuthException &&
                            FirebaseAuthExceptionCode.fromErrorCode(
                                    error.code) ==
                                FirebaseAuthExceptionCode.requiresRecentLogin) {
                          requiresRecentLoginExeptionThrown.value = true;
                          return;
                        }

                        if (context.mounted) {
                          await closeAllDialogs(context);
                        }
                        if (context.mounted) {
                          ExeptionHandlerService.handleExeption(
                            context,
                            error,
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  icon: const Icon(LucideIcons.user_round_x),
                  label: const Text("Konto löschen"),
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
          Tooltip(
            message: "Schließen",
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Icon(LucideIcons.circle_x),
            ),
          ),
          const SizedBox(width: Spacing.small),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              try {
                await UserService.updateStats(
                  name: usernameController.text,
                  email: emailController.text,
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (error) {
                if (context.mounted) {
                  ExeptionHandlerService.handleExeption(context, error);
                }
              }
            },
            child: const Text("Speichern"),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends HookWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      icon: const Icon(LucideIcons.key),
      title: const Text("Passwort ändern"),
      content: Form(
        key: formKey,
        child: CustomTextField.password(
          controller: passwordController,
          labelText: "Password",
          validate: true,
        ),
      ),
      actions: [
        Tooltip(
          message: "Schließen",
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Icon(LucideIcons.circle_x),
          ),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }

            try {
              await UserService.updatePassword(
                newPassword: passwordController.text,
              );

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } catch (error) {
              if (context.mounted) {
                ExeptionHandlerService.handleExeption(context, error);
              }
            }
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}
