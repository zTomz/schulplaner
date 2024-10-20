import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/domain/provider/auth_provider.dart';
import 'package:schulplaner/features/auth/presentation/provider/state/auth_notifier.dart';
import 'package:schulplaner/features/auth/presentation/provider/state/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateWrapper>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);
