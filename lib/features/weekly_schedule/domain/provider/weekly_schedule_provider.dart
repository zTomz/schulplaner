import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/data/data_sources/weekly_schedule_data_source.dart';
import 'package:schulplaner/features/weekly_schedule/data/data_sources/weekly_schedule_remote_data_source.dart';
import 'package:schulplaner/features/weekly_schedule/data/repositories/weekly_schedule_repository_impl.dart';
import 'package:schulplaner/features/weekly_schedule/domain/repositories/weekly_schedule_repository.dart';

final weeklyScheduleSourceProvider = Provider<WeeklyScheduleDataSource>((ref) {
  return WeeklyScheduleRemoteDataSource();
});

final weeklyScheduleRepositoryProvider = Provider<WeeklyScheduleRepository>((ref) {
  final dataSource = ref.watch(weeklyScheduleSourceProvider);

  return WeeklyScheduleRepositoryImpl(dataSource: dataSource);
});