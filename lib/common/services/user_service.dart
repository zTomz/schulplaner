import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/services/exeption_handler_service.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';

abstract class UserService {
  static Future<void> updateStats(
    BuildContext context, {
    String? name,
    String? email,
  }) async {
    // Show an error if no user is logged in.
    if (!_checkUserIsSignedIn(context)) {
      return;
    }

    // If the name is not null, we will update it
    if (name != null) {
      // This function doesnt throw errors, but if it will fail because of some reason. It will
      // show an error
      try {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(
          name,
        );
      } catch (_) {
        if (context.mounted) {
          SnackBarService.show(
            context: context,
            content: const Text("Es gibt einen Fehler mit Ihrem Namen."),
            type: CustomSnackbarType.error,
          );
        }
      }
    }

    // If the email is not null, we will update it
    if (email != null) {
      try {
        await FirebaseAuth.instance.currentUser!.updateEmail(
          email,
        );
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          ExeptionHandlerService.handleFirebaseAuthException(context, e);
        }
      } catch (e) {
        if (context.mounted) {
          SnackBarService.show(
            context: context,
            content: const Text("Ein unbekannter Fehler ist aufgetreten."),
            type: CustomSnackbarType.error,
          );
        }
      }
    }
  }

  /// Delete the user and handle the errors
  static Future<void> deleteAccount(BuildContext context) async {
    if (!_checkUserIsSignedIn(context)) {
      return;
    }

    // TODO: Add things that need to be deleted with the account here

    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ExeptionHandlerService.handleFirebaseAuthException(context, e);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.show(
          context: context,
          content: const Text("Ein unbekannter Fehler ist aufgetreten."),
          type: CustomSnackbarType.error,
        );
      }
    }
  }

  /// Checkes if the user is signed in. If not it will show an error and return [false]
  static bool _checkUserIsSignedIn(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      SnackBarService.show(
        context: context,
        content: const Text(
          "Sie benötigen einen Account um diese Action auszuführen.",
        ),
        type: CustomSnackbarType.error,
      );

      return false;
    }

    return true;
  }
}
