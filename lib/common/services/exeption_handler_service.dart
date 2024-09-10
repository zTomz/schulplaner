import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';

abstract class ExeptionHandlerService {
  /// Handle firebase auth exceptions
  static void handleFirebaseAuthException(
    BuildContext context,
    FirebaseAuthException exeption,
  ) {
    switch (_FirebaseAuthExceptionCode.fromErrorCode(exeption.code)) {
      case _FirebaseAuthExceptionCode.emailAlreadyInUse:
        SnackBarService.show(
          context: context,
          content: const Text("Die E-Mail Adresse ist bereits vergeben."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.weakPassword:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Das Passwort ist zu schwach. Bitte geben Sie ein stärkeres Passwort ein."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.invalidEmail:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Die E-Mail Adresse ist ungültig. Bitte geben Sie eine gültige E-Mail Adresse ein."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.operationNotAllowed:
        SnackBarService.show(
          context: context,
          content: const Text("Die E-Mail ist momentan deaktiviert."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.userDisabled:
        SnackBarService.show(
          context: context,
          content: const Text("Der angegebene Nutzer ist deaktiviert."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.userNotFound:
        SnackBarService.show(
          context: context,
          content: const Text(
              "Es wurde kein Nutzer mit diesen Anmeldedaten gefunden."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.wrongPassword:
        SnackBarService.show(
          context: context,
          content: const Text("Das Passwort ist ungültig."),
          type: CustomSnackbarType.error,
        );
      case _FirebaseAuthExceptionCode.requiresRecentLogin:
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
}

enum _FirebaseAuthExceptionCode {
  emailAlreadyInUse('email-already-in-use'),
  invalidEmail('invalid-email'),
  operationNotAllowed('operation-not-allowed'),
  weakPassword('weak-password'),
  userDisabled('user-disabled'),
  userNotFound('user-not-found'),
  wrongPassword('wrong-password'),
  requiresRecentLogin('requires-recent-login');

  final String errorCode;

  const _FirebaseAuthExceptionCode(this.errorCode);

  static _FirebaseAuthExceptionCode? fromErrorCode(String errorCode) {
    for (final code in _FirebaseAuthExceptionCode.values) {
      if (code.errorCode == errorCode) {
        return code;
      }
    }

    return null;
  }
}
