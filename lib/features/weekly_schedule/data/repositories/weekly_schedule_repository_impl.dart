import 'package:schulplaner/features/weekly_schedule/data/data_sources/weekly_schedule_data_source.dart';
import 'package:schulplaner/features/weekly_schedule/domain/repositories/weekly_schedule_repository.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

class WeeklyScheduleRepositoryImpl implements WeeklyScheduleRepository {
  final WeeklyScheduleDataSource dataSource;

  WeeklyScheduleRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<UnauthenticatedException, void>> uploadWeeklyScheduleData({
    required WeeklyScheduleData weeklyScheduleData,
  }) async {
    return dataSource.uploadWeeklyScheduleData(
      weeklyScheduleData: weeklyScheduleData,
    );
  }
}
