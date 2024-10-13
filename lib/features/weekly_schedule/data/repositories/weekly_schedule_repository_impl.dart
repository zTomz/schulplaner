import 'package:schulplaner/features/weekly_schedule/data/datasources/weekly_schedule_data_source.dart';
import 'package:schulplaner/features/weekly_schedule/domain/repositories/weekly_schedule_repository.dart';
import 'package:schulplaner/shared/exeptions/auth_exeptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

class WeeklyScheduleRepositoryImpl implements WeeklyScheduleRepository {
  final WeeklyScheduleDataSource dataSource;

  WeeklyScheduleRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadWeeklyScheduleData({
    required WeeklyScheduleData weeklyScheduleData,
  }) async {
    return dataSource.uploadWeeklyScheduleData(
      weeklyScheduleData: weeklyScheduleData,
    );
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadLessons({
    required List<Lesson> lessons,
  }) async {
    return dataSource.uploadLessons(
      lessons: lessons,
    );
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadSubjects({
    required List<Subject> subjects,
  }) async {
    return dataSource.uploadSubjects(
      subjects: subjects,
    );
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadTeachers({
    required List<Teacher> teachers,
  }) async {
    return dataSource.uploadTeachers(
      teachers: teachers,
    );
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadTimeSpans({
    required Set<TimeSpan> timeSpans,
  }) async {
    return dataSource.uploadTimeSpans(
      timeSpans: timeSpans,
    );
  }
}
