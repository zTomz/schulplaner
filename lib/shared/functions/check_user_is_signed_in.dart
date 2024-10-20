import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';

/// Checkes if the user is signed in. If not it will show an error and return [false]
bool checkUserIsSignedIn(BuildContext context) {
  if (FirebaseAuth.instance.currentUser == null) {
    SnackBarService.show(
      context: context,
      content: const Text(
        "Sie benötigen ein Konto um diese Action auszuführen.",
      ),
      type: CustomSnackbarType.error,
    );

    return false;
  }

  return true;
}
