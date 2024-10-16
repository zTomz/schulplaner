import 'package:equatable/equatable.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';

class AuthStateWrapper extends Equatable {
  final AuthState state;
  final AuthExeption? exeption;

  const AuthStateWrapper._(this.state, this.exeption);

  const AuthStateWrapper.initial() : this._(AuthState.initial, null);
  const AuthStateWrapper.loading() : this._(AuthState.loading, null);
  const AuthStateWrapper.success() : this._(AuthState.success, null);
  const AuthStateWrapper.error(AuthExeption exeption)
      : this._(
          AuthState.error,
          exeption,
        );

  @override
  List<Object?> get props => [state, exeption];

  bool get isSuccess => state == AuthState.success;

  bool get isLoading => state == AuthState.loading;

  bool get hasError => state == AuthState.error;
}

enum AuthState {
  initial,
  loading,
  success,
  error;
}
