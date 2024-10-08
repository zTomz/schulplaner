class AuthException implements Exception {
  AuthException();

  @override
  String toString() {
    return "Sie müssen angemeldet sein, um diese Aktion auszuführen.";
  }
}
