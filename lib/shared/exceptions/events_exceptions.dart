class EventsSyncPreviousException implements Exception {
  const EventsSyncPreviousException({
    required this.previousException,
  }) : message =
            "Die Ereignisse konnten nicht mit der Datenbank synchronisiert werden. Da ein vorheriger Fehler existiert.";

  /// The error message
  final String message;

  /// The previous exeption
  final Object previousException;
}
