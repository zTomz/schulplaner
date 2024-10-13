/// Thrown when because of a previous exeption, the code cannot be executed
class WeeklyScheduleSyncPreviousException implements Exception {
  const WeeklyScheduleSyncPreviousException({
    required this.previousException,
  }) : message =
            "Der Stundenplan konnte nicht mit der Datenbank synchronisiert werden. Da ein vorheriger Fehler existiert.";

  /// The error message
  final String message;

  /// The previous exeption
  final Object previousException;
}
