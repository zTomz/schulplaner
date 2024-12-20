import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/functions/close_all_dialogs.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/services/exception_handler_service.dart';
import 'package:schulplaner/shared/services/user_service.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';

/// Shows the [AccountDialog].
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
                await showCustomDialog(
                  context: context,
                  builder: (context) {
                    return const ChangePasswordDialog();
                  },
                );
              },
              child: const Text("Passwort ändern"),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showLicensePage(context: context);
            },
            tooltip: "Lizenzen",
            icon: const Icon(LucideIcons.copyright),
          ),
          IconButton(
            onPressed: () async {
              await showCustomDialog(
                context: context,
                builder: (context) => const AccountSettingsDialog(),
              );
            },
            tooltip: "Konto Einstellungen",
            icon: const Icon(LucideIcons.user_cog),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            tooltip: "Schließen",
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(LucideIcons.circle_x),
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
                  ExceptionHandlerService.handleException(context, error);
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
      icon: const Icon(LucideIcons.key_round),
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
        IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          tooltip: "Schließen",
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(LucideIcons.circle_x),
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
                ExceptionHandlerService.handleException(context, error);
              }
            }
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}

class AccountSettingsDialog extends HookWidget {
  const AccountSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final requiresRecentLoginExceptionThrown = useState(false);

    return CustomDialog(
      icon: const Icon(LucideIcons.user_cog),
      title: const Text("Konto Einstellungen"),
      error: requiresRecentLoginExceptionThrown.value
          ? const Text(
              "Sie müssen sich erneut Anmelden, da die von Ihnen ausgeführte Aktion einen neuen Login benötigt.")
          : null,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
          const SizedBox(height: Spacing.small),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showCustomDialog<bool>(
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
                      FirebaseAuthExceptionCode.fromErrorCode(error.code) ==
                          FirebaseAuthExceptionCode.requiresRecentLogin) {
                    requiresRecentLoginExceptionThrown.value = true;
                    return;
                  }

                  if (context.mounted) {
                    await closeAllDialogs(context);
                  }
                  if (context.mounted) {
                    ExceptionHandlerService.handleException(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Schließen"),
        ),
      ],
    );
  }
}
