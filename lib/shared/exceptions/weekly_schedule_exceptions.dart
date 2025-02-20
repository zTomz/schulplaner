class WeeklyScheduleException implements Exception {
  final String message;

  const WeeklyScheduleException({
    required this.message,
  });
}

/// Thrown when because of a previous exeption, the code cannot be executed
class WeeklyScheduleSyncPreviousException extends WeeklyScheduleException {
  const WeeklyScheduleSyncPreviousException({
    required this.previousException,
  }) : super(
          message:
              "Der Stundenplan konnte nicht mit der Datenbank synchronisiert werden. Da ein vorheriger Fehler existiert.",
        );

  /// The previous exeption
  final Object previousException;
}

/// If the provided subject does not exist inside the weekly schedule
class SubjectDoesNotExistException extends WeeklyScheduleException {
  const SubjectDoesNotExistException() : super(
        message: "Das angegebene Fach existiert nicht im Stundenplan.",
      );
}
