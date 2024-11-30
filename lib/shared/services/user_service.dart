import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/config/constants/logger.dart';

abstract class UserService {
  /// Update the stats of the user. Currently only the name and the email can be updated.
  /// If not possible show an error
  static Future<void> updateStats({
    String? name,
    String? email,
  }) async {
    // Show an error if no user is logged in.
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to update his stats.");
      throw UnauthenticatedException();
    }

    // If the name is not null, we will update it
    if (name != null) {
      // This function doesn't throw errors, but if it will fail because of some reason. It will
      // show an error
      try {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(
          name.trim(),
        );
      } catch (error) {
        logger.e(
          "Unknown error while updating the name.",
          error: error,
        );
        rethrow;
      }
    }

    // If the email is not null, we will update it
    if (email != null) {
      try {
        await FirebaseAuth.instance.currentUser!.updateEmail(
          email.trim(),
        );
      } on FirebaseAuthException catch (e) {
        logger.e(
          "Firebase Auth Exception while updating the email.",
          error: e,
        );
        rethrow;
      } catch (e) {
        logger.e(
          "Unknown error while updating the email.",
          error: e,
        );
        rethrow;
      }
    }
  }

  /// Update the password if possible. Else show an error
  static Future<void> updatePassword({
    required String newPassword,
  }) async {
    // Show an error if no user is logged in.
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to update his password.");
      throw UnauthenticatedException();
    }

    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Firebase Auth Exception while updating the password.",
        error: e,
      );
      rethrow;
    } catch (e) {
      logger.e(
        "Unknown error while updating the password.",
        error: e,
      );
      rethrow;
    }
  }

  /// Update the FCM token
  // static Future<void> updateFCMToken({
  //   required String fcmToken,
  // }) async {
  //   if (FirebaseAuth.instance.currentUser == null) {
  //     logger.e("The user need to be signed in to update his FCM token.");
  //     throw UnauthenticatedException();
  //   }

  //   final doc = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   if (doc.exists) {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({"fcmToken": fcmToken});
  //   } else {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .set({"fcmToken": fcmToken});
  //   }
  // }

  /// Delete the user and handle the errors
  static Future<void> deleteAccount() async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to delete his account.");
      throw UnauthenticatedException();
    }

    // Delete the account
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Firebase Auth Exception while deleting the account.",
        error: e,
      );
      rethrow;
    } catch (e) {
      logger.e(
        "Unknown error while deleting the account.",
        error: e,
      );
      rethrow;
    }
  }
}
