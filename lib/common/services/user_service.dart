import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/check_user_is_signed_in.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/services/database_service.dart';
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

  /// Delete the user and handle the errors
  static Future<void> deleteAccount(BuildContext context) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // We have to save this uid, because we cannot access it after account deletion, but we need it to delete the document
    final oldUserUid = FirebaseAuth.instance.currentUser!.uid;

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

    // TODO: Add things that need to be deleted along with the account here...

    // Delete the user documents. Info, we have to delete all documents from the collection first and then delete the user doc
    // TODO: Write a cloud function, that deletes the user document
    final documents = await DatabaseService.userCollection
        .doc(oldUserUid)
        .collection("weekly_schedule")
        .get()
        .then((value) => value.docs);
    for (final document in documents) {

      await DatabaseService.userCollection
          .doc(oldUserUid)
          .collection("weekly_schedule")
          .doc(document.id)
          .delete();
    }

    // Delete the user doc
    await DatabaseService.userCollection.doc(oldUserUid).delete();
  }
}
