import 'package:schulplaner/shared/exeptions/auth_exeptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

abstract class WeeklyScheduleRepository {
  /// Upload the weekly schedule data. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadWeeklyScheduleData({
    required WeeklyScheduleData weeklyScheduleData,
  });

  /// Upload the time spans. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadSubjects({
    required List<Subject> subjects,
  });

  /// Upload the teachers. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadTeachers({
    required List<Teacher> teachers,
  });

  /// Upload the subjects. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadLessons({
    required List<Lesson> lessons,
  });

  /// Upload the lessons. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadTimeSpans({
    required Set<TimeSpan> timeSpans,
  });
}
