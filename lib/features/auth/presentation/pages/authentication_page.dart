import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/auth/presentation/provider/auth_provider.dart';
import 'package:schulplaner/features/auth/presentation/provider/state/auth_state.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/widgets/loading_overlay.dart';

@RoutePage()
class AuthenticationPage extends HookConsumerWidget {
  const AuthenticationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final isSigningUp = useState<bool>(false);

    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return GradientScaffold(
      body: _buildBox(
        formKey: formKey,
        authState: authState,
        children: [
          Text(
            isSigningUp.value ? "Konto erstellen" : "Anmelden",
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
         
          const SizedBox(height: Spacing.large),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                if (isSigningUp.value) ...[
                  CustomTextField(
                    controller: usernameController,
                    labelText: "Name",
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(LucideIcons.user),
                    validate: true,
                  ),
                  const SizedBox(height: Spacing.small),
                ],
                CustomTextField.email(
                  controller: emailController,
                  labelText: "E-Mail",
                  validate: true,
                ),
                const SizedBox(height: Spacing.small),
                CustomTextField.password(
                  controller: passwordController,
                  labelText: "Password",
                  validate: true,
                ),
                const SizedBox(height: Spacing.medium),
                CustomButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    AuthStateWrapper result;

                    if (isSigningUp.value) {
                      result = await ref
                          .read(authProvider.notifier)
                          .signUpWithEmailPassword(
                            email: emailController.text,
                            password: passwordController.text,
                            displayName: usernameController.text,
                          );
                    } else {
                      // If the users signes in, we do not want to override the current weekly schedule and hobby data
                      result = await ref
                          .read(authProvider.notifier)
                          .signInWithEmailPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    }

                    /// Handle the result of the authentication
                    if (result.isSuccess && context.mounted) {
                      context.router.replaceAll([
                        const AppNavigationRoute(),
                      ]);
                    } else if (result.hasError && context.mounted) {
                      SnackBarService.show(
                        context: context,
                        content: Text(result.exeption!.message),
                        type: CustomSnackbarType.error,
                      );
                    } else {
                      logger.w(
                        "Something went wrong. Got an unexpected auth state. authState: $authState",
                      );
                    }
                  },
                  child: Text(
                    isSigningUp.value ? "Konto erstellen" : "Anmelden",
                  ),
                ),
                const SizedBox(height: Spacing.small),
                TextButton(
                  onPressed: () async {
                    formKey.currentState!.reset();
                    isSigningUp.value = !isSigningUp.value;
                  },
                  child: Text(
                    isSigningUp.value
                        ? "Sie haben bereits ein Konto?"
                        : "Sie haben noch kein Konto?",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox({
    required GlobalKey<FormState> formKey,
    required AuthStateWrapper authState,
    required List<Widget> children,
  }) =>
      Builder(
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.7,
              height: MediaQuery.sizeOf(context).height * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(kDefaultOpacity),
                borderRadius: const BorderRadius.all(Radii.medium),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Spacing.large),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      ),
                    ),
                  ),
                  if (authState.isLoading) const LoadingOverlay(),
                ],
              ),
            ),
          );
        },
      );
}
