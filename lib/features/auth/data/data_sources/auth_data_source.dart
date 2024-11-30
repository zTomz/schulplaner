import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';

abstract class AuthDataSource {
  /// Create a new user with the provided email and password
  Future<Either<AuthException, UserCredential>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign the user in with the provided email and password
  Future<Either<AuthException, UserCredential>> signInWithEmailPassword({
    required String email,
    required String password,
  });
}
