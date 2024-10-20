/// Thrown when because of a previous exeption, the code cannot be executed
class HobbiesSyncPreviousException implements Exception {
  const HobbiesSyncPreviousException({
    required this.previousException,
  }) : message =
            "Die Hobbbies konnten nicht mit der Datenbank synchronisiert werden. Da ein vorheriger Fehler existiert.";

  /// The error message
  final String message;

  /// The previous exeption
  final Object previousException;
}
