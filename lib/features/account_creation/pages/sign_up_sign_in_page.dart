import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/services/auth_service.dart';
import 'package:schulplaner/common/services/database_service.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

@RoutePage()
class SignUpSignInPage extends HookWidget {
  /// The weekly schedule if created from the [create_weekly_schedule_page.dart]
  final WeeklyScheduleData? weeklyScheduleData;

  /// The teachers if created from the [create_weekly_schedule_page.dart]
  final List<Teacher>? teachers;

  /// The subjects if created from the [create_weekly_schedule_page.dart]
  final List<Subject>? subjects;

  /// The hobbies from the create hobbies page
  final List<Hobby>? hobbies;

  const SignUpSignInPage({
    super.key,
    this.weeklyScheduleData,
    this.teachers,
    this.subjects,
    this.hobbies,
  });

  @override
  Widget build(BuildContext context) {
    final isSigningUp = useState<bool>(true);

    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return GradientScaffold(
      body: _buildBox(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSigningUp.value ? "Konto erstellen" : "Anmelden",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.small),
              Text(
                isSigningUp.value
                    ? "Zuletzt müssen Sie ein Konto erstellen, dann kann es losgehen!"
                    : "Melden Sie sich nun noch bei Ihrem Konto an, um loszulegen.",
                style: Theme.of(context).textTheme.headlineSmall,
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

                        if (isSigningUp.value) {
                          final result = await AuthService.createAccount(
                            context,
                            name: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (result != null && context.mounted) {
                            // Upload the weekly schedule data, teachers, subjects and the hobbies
                            await _createUserData(context);

                            if (context.mounted) {
                              context.router.replaceAll([
                                const AppNavigationRoute(),
                              ]);
                            }
                          }
                        } else {
                          // If the users signes in, we do not want to override the current weekly schedule and hobby data
                          final result = await AuthService.signIn(
                            context,
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (result != null && context.mounted) {
                            context.router.replaceAll([
                              const AppNavigationRoute(),
                            ]);
                          }
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createUserData(BuildContext context) async {
    if (weeklyScheduleData != null) {
      await DatabaseService.uploadWeeklySchedule(
        context,
        weeklyScheduleData: weeklyScheduleData!,
      );
    }
    if (teachers != null && teachers!.isNotEmpty && context.mounted) {
      await DatabaseService.uploadTeachers(
        context,
        teachers: teachers!,
      );
    }
    if (subjects != null && teachers!.isNotEmpty && context.mounted) {
      await DatabaseService.uploadSubjects(
        context,
        subjects: subjects!,
      );
    }

    if (hobbies != null && context.mounted) {
      await DatabaseService.uploadHobbies(
        context,
        hobbies: hobbies!,
      );
    }
  }

  Widget _buildBox({
    required Widget child,
  }) =>
      Builder(
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(Spacing.large),
              width: MediaQuery.sizeOf(context).width * 0.7,
              height: MediaQuery.sizeOf(context).height * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(kDefaultOpacity),
                borderRadius: const BorderRadius.all(Radii.medium),
              ),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          );
        },
      );
}
