class UnauthenticatedException implements Exception {
  final String message;

  UnauthenticatedException()
      : message = "Sie müssen angemeldet sein, um diese Aktion auszuführen.";
}

class AuthException implements Exception {
  AuthException(
    this.message,
  );

  final String message;

  AuthException.fromErrorCode(String errorCode)
      : message = FirebaseAuthExceptionCode.fromErrorCode(errorCode)?.message ??
            AuthException.unknown().message;

  AuthException.unknown() : message = "Ein unbekannter Fehler ist aufgetreten.";
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

  String get message {
    switch (this) {
      case FirebaseAuthExceptionCode.emailAlreadyInUse:
        return "Die E-Mail Adresse ist bereits vergeben.";
      case FirebaseAuthExceptionCode.weakPassword:
        return "Das Passwort ist zu schwach. Bitte geben Sie ein stärkeres Passwort ein.";
      case FirebaseAuthExceptionCode.invalidEmail:
        return "Die E-Mail Adresse ist ungültig. Bitte geben Sie eine gültige E-Mail Adresse ein.";
      case FirebaseAuthExceptionCode.operationNotAllowed:
        return "Die Operation ist nicht erlaubt.";
      case FirebaseAuthExceptionCode.userDisabled:
        return "Dieses Konto ist deaktiviert.";
      case FirebaseAuthExceptionCode.userNotFound:
        return "Es konnte kein Konto mit diesen Anmeldedaten gefunden werden.";
      case FirebaseAuthExceptionCode.wrongPassword:
        return "Das angegebene Passwort ist ungültig.";
      case FirebaseAuthExceptionCode.requiresRecentLogin:
        return "Sie müssen sich erneut Anmelden, da die von Ihnen ausgeführte Aktion einen neuen Login benötigt.";
    }
  }
}
