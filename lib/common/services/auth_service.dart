import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/services/exeption_handler_service.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';

abstract class AuthService {
  /// Create a new account. This function also handels the errors and shows corresponding snackbar messages
  static Future<UserCredential?> createAccount(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;

    try {
      // Create the account
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        ExeptionHandlerService.handleFirebaseAuthException(context, e);
      }

      return null;
    } catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        SnackBarService.show(
          context: context,
          content: const Text("Ein unbekannter Fehler ist aufgetreten."),
          type: CustomSnackbarType.error,
        );
      }

      return null;
    }

    // Update the name
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

    return userCredential;
  }

  static Future<UserCredential?> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        ExeptionHandlerService.handleFirebaseAuthException(context, e);
      }

      return null;
    } catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        SnackBarService.show(
          context: context,
          content: const Text("Ein unbekannter Fehler ist aufgetreten."),
          type: CustomSnackbarType.error,
        );
      }

      return null;
    }

    return userCredential;
  }
}
