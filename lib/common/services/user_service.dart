import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/check_user_is_signed_in.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/services/exeption_handler_service.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';

abstract class UserService {
  /// Update the stats of the user. Currently only the name and the email can be updated.
  /// If not possible show an error
  static Future<void> updateStats(
    BuildContext context, {
    String? name,
    String? email,
  }) async {
    // Show an error if no user is logged in.
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // If the name is not null, we will update it
    if (name != null) {
      // This function doesnt throw errors, but if it will fail because of some reason. It will
      // show an error
      try {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(
          name.trim(),
        );
      } catch (_) {
        if (context.mounted) {
          await closeAllDialogs(context);
        }
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
          email.trim(),
        );
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          await closeAllDialogs(context);
        }
        if (context.mounted) {
          ExeptionHandlerService.handleFirebaseAuthException(context, e);
        }
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
      }
    }
  }

  /// Update the password if possible. Else show an error
  static Future<void> updatePassword(
    BuildContext context, {
    required String newPassword,
  }) async {
    // Show an error if no user is logged in.
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        ExeptionHandlerService.handleFirebaseAuthException(context, e);
      }
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
    }
  }

  /// Update the FCM token
  static Future<void> updateFCMToken({
    required String fcmToken,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fcmToken": fcmToken});
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"fcmToken": fcmToken});
    }
  }

  /// Delete the user and handle the errors
  static Future<void> deleteAccount(BuildContext context) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // Delete the account
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await closeAllDialogs(context);
      }
      if (context.mounted) {
        ExeptionHandlerService.handleFirebaseAuthException(context, e);
      }
      return;
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
      return;
    }

    // The delete user function deletes the documents and the rest.
    // TODO: If we add images or other things, we need to add them to the Delete User Data extension in Firebase
  }
}
