import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

abstract class WeeklyScheduleRepository {
  /// Upload the weekly schedule data. Checks if the user is authenticated, if not
  /// returns an [UnauthenticatedExeption].
  Future<Either<UnauthenticatedExeption, void>> uploadWeeklyScheduleData({
    required WeeklyScheduleData weeklyScheduleData,
  });
}
