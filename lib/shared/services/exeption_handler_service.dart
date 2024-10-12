import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/shared/exeptions/auth_exeptions.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';

abstract class ExeptionHandlerService {
  /// Handle all `Exception`'s. Will use specific functions, if the error is implemented
  static void handleExeption(BuildContext context, Object exception) {
    if (exception is UnauthenticatedExeption) {
      handleAuthException(context, exception);
      return;
    }

    if (exception is FirebaseAuthException) {
      handleFirebaseAuthException(context, exception);
      return;
    }

    handleUnknownError(context);
  }

  /// Handle `FirebaseAuthException`'s
  static void handleFirebaseAuthException(
    BuildContext context,
    FirebaseAuthException exeption,
  ) {
    final firebaseAuthExeption =
        FirebaseAuthExceptionCode.fromErrorCode(exeption.code);

    if (firebaseAuthExeption != null) {
      SnackBarService.show(
        context: context,
        content: Text(firebaseAuthExeption.message),
        type: CustomSnackbarType.error,
      );
    } else {
      SnackBarService.show(
        context: context,
        content: const Text("Ein unbekannter Fehler ist aufgetreten."),
        type: CustomSnackbarType.error,
      );
    }
  }

  /// Handle an `AuthException`
  static void handleAuthException(
    BuildContext context,
    UnauthenticatedExeption exception,
  ) {
    SnackBarService.show(
      context: context,
      content: Text(exception.toString()),
      type: CustomSnackbarType.error,
    );
  }

  /// Handle an unknown error
  static void handleUnknownError(BuildContext context) {
    SnackBarService.show(
      context: context,
      content: const Text("Ein unbekannter Fehler ist aufgetreten."),
      type: CustomSnackbarType.error,
    );
  }
}
