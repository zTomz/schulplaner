import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/services/exeptions.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';

abstract class ExeptionHandlerService {
  /// Handle all `Exception`'s. Will use specific functions, if the error is implemented
  static void handleExeption(BuildContext context, Object exception) {
    if (exception is AuthException) {
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
    switch (FirebaseAuthExceptionCode.fromErrorCode(exeption.code)) {
      case FirebaseAuthExceptionCode.emailAlreadyInUse:
        SnackBarService.show(
          context: context,
          content: const Text("Die E-Mail Adresse ist bereits vergeben."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.weakPassword:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Das Passwort ist zu schwach. Bitte geben Sie ein stärkeres Passwort ein."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.invalidEmail:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Die E-Mail Adresse ist ungültig. Bitte geben Sie eine gültige E-Mail Adresse ein."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.operationNotAllowed:
        SnackBarService.show(
          context: context,
          content: const Text("Die E-Mail ist momentan deaktiviert."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.userDisabled:
        SnackBarService.show(
          context: context,
          content: const Text("Der angegebene Nutzer ist deaktiviert."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.userNotFound:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Es wurde kein Nutzer mit diesen Anmeldedaten gefunden."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.wrongPassword:
        SnackBarService.show(
          context: context,
          content: const Text("Das Passwort ist ungültig."),
          type: CustomSnackbarType.error,
        );
      case FirebaseAuthExceptionCode.requiresRecentLogin:
        SnackBarService.show(
          context: context,
          content: const Text(
            "Sie müssen sich erneut Anmelden, da die von Ihnen ausgefürhte Aktion einen neuen Login benötigt.",
          ),
          type: CustomSnackbarType.error,
        );
      default:
        SnackBarService.show(
          context: context,
          content: const Text("Ein unbekannter Fehler ist aufgetreten."),
          type: CustomSnackbarType.error,
        );
    }
  }

  /// Handle an `AuthException`
  static void handleAuthException(
      BuildContext context, AuthException exception) {
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

enum FirebaseAuthExceptionCode {
  emailAlreadyInUse('email-already-in-use'),
  invalidEmail('invalid-email'),
  operationNotAllowed('operation-not-allowed'),
  weakPassword('weak-password'),
  userDisabled('user-disabled'),
  userNotFound('user-not-found'),
  wrongPassword('wrong-password'),
  requiresRecentLogin('requires-recent-login');

  final String errorCode;

  const FirebaseAuthExceptionCode(this.errorCode);

  static FirebaseAuthExceptionCode? fromErrorCode(String errorCode) {
    for (final code in FirebaseAuthExceptionCode.values) {
      if (code.errorCode == errorCode) {
        return code;
      }
    }

    return null;
  }
}
