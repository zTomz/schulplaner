import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';

abstract class AuthService {
  /// Create a new account. This will create a new Firebase user and update the display name.
  /// If an error occurs, it will log it and then rethrown
  static Future<UserCredential?> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;

    try {
      // Create the account
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while creation the account.",
        error: e,
      );
      rethrow;
    } catch (e) {
      logger.e(
        "Unknown error occurred, while creating the account.",
        error: e,
      );

      rethrow;
    }

    // Update the name
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name.trim());

    return userCredential;
  }

  /// Sign the user in and return the user credential. If an error occurs, it will log it and
  /// then rethrown
  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while signing in.",
        error: e,
      );

      rethrow;
    } catch (e) {
      logger.e(
        "Unknown error occurred, while signing in.",
        error: e,
      );

      rethrow;
    }

    return userCredential;
  }
}
