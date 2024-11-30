import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/auth/data/data_sources/auth_data_source.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';

class AuthRemoteDataSource implements AuthDataSource {
  @override
  Future<Either<AuthException, UserCredential>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create the account
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update the display name
      await credential.user!.updateDisplayName(displayName);

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while creation the account.",
        error: e,
      );

      return Left(AuthException.fromErrorCode(e.code));
    } catch (e) {
      logger.e(
        "Unknown error occurred, while creating the account.",
        error: e,
      );

      return Left(AuthException.unknown());
    }
  }

  @override
  Future<Either<AuthException, UserCredential>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign the user in
      return Right(
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while signing in.",
        error: e,
      );

      return Left(AuthException.fromErrorCode(e.code));
    } catch (e) {
      logger.e(
        "Unknown error occurred, while signing in.",
        error: e,
      );

      return Left(AuthException.unknown());
    }
  }
}
