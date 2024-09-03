import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schulplaner/common/constants/svg_pictures.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';
import 'package:schulplaner/features/account_creation/models/create_weekly_schedule_data.dart';

@RoutePage()
class SignUpSignInPage extends HookWidget {
  /// The data from the create weekly schedule page
  final CreateWeeklyScheduleData createWeeklyScheduleData;

  /// The hobbies from the create hobbies page
  final List<Hobby> hobbies;

  const SignUpSignInPage({
    super.key,
    required this.createWeeklyScheduleData,
    required this.hobbies,
  });

  @override
  Widget build(BuildContext context) {
    final isSigningUp = useState<bool>(true);

    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return GradientScaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(Spacing.large),
          width: MediaQuery.sizeOf(context).width * 0.7,
          height: MediaQuery.sizeOf(context).height * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radii.medium),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSigningUp.value
                      ? "Erstelle einen Account"
                      : "Melden Sie sich an",
                  style: TextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.small),
                Text(
                  isSigningUp.value
                      ? "Zuletzt müssen Sie einen Account erstellen, dann kann es losgehen!"
                      : "Melden Sie sich nun noch bei Ihrem Account an, um loszulegen.",
                  style: TextStyles.body,
                  textAlign: TextAlign.center,
                  softWrap: true,
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
                      CustomTextField(
                        controller: emailController,
                        labelText: "E-Mail",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(LucideIcons.mail),
                        validate: true,
                      ),
                      const SizedBox(height: Spacing.small),
                      CustomTextField.password(
                        controller: passwordController,
                        labelText: "Password",
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(LucideIcons.key_round),
                        validate: true,
                      ),
                      const SizedBox(height: Spacing.medium),
                      CustomButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          // TODO: Create the user or sign him in
                        },
                        child: Text(
                          isSigningUp.value ? "Account erstellen" : "Einloggen",
                        ),
                      ),
                      const SizedBox(height: Spacing.small),
                      TextButton(
                        onPressed: () {
                          isSigningUp.value = !isSigningUp.value;
                        },
                        child: Text(
                          isSigningUp.value
                              ? "Sie haben bereits einen Account?"
                              : "Sie haben noch keinen Account?",
                        ),
                      ),
                      const SizedBox(height: Spacing.small),
                      SizedBox.square(
                        dimension: 50,
                        child: Material(
                          color: Colors.white,
                          type: MaterialType.button,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(360),
                            child: Padding(
                              padding: const EdgeInsets.all(Spacing.small),
                              child: SvgPicture.asset(
                                SvgPictures.googleLogo,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
