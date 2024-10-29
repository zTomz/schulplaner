import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/domain/repositories/auth_repository.dart';
import 'package:schulplaner/features/auth/presentation/provider/state/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthStateWrapper> {
  final AuthRepository authRepository;

  AuthNotifier(this.authRepository) : super(const AuthStateWrapper.initial());

  Future<AuthStateWrapper> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthStateWrapper.loading();
    final result = await authRepository.signInWithEmailPassword(
        email: email, password: password);
    result.fold(
      (l) => state = AuthStateWrapper.error(l),
      (r) => state = const AuthStateWrapper.success(),
    );

    return state;
  }

  Future<AuthStateWrapper> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthStateWrapper.loading();
    final result = await authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
    result.fold(
      (l) => state = AuthStateWrapper.error(l),
      (r) => state = const AuthStateWrapper.success(),
    );

    return state;
  }
}
