import 'package:equatable/equatable.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';

class AuthStateWrapper extends Equatable {
  final AuthState state;
  final AuthException? exception;

  const AuthStateWrapper._(this.state, this.exception);

  const AuthStateWrapper.initial() : this._(AuthState.initial, null);
  const AuthStateWrapper.loading() : this._(AuthState.loading, null);
  const AuthStateWrapper.success() : this._(AuthState.success, null);
  const AuthStateWrapper.error(AuthException exception)
      : this._(
          AuthState.error,
          exception,
        );

  @override
  List<Object?> get props => [state, exception];

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
