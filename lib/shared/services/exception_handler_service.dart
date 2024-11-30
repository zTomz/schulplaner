import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/services/snack_bar_service.dart';

abstract class ExceptionHandlerService {
  /// Handle all `Exception`'s. Will use specific functions, if the error is implemented
  static void handleException(BuildContext context, Object exception) {
    if (exception is UnauthenticatedException) {
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
    FirebaseAuthException exception,
  ) {
    final firebaseAuthException =
        FirebaseAuthExceptionCode.fromErrorCode(exception.code);

    if (firebaseAuthException != null) {
      SnackBarService.show(
        context: context,
        content: Text(firebaseAuthException.message),
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
    UnauthenticatedException exception,
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
