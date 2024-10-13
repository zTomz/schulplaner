import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/domain/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/state/weekly_schedule_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/provider/weekly_schedule_stream_provider.dart';

final weeklyScheduleProvider = StateNotifierProvider<WeeklyScheduleNotifier,
    Either<Exception, WeeklyScheduleData>>((ref) {
  final weeklyScheduleRepository = ref.watch(weeklyScheduleRepositoryProvider);
  final weeklyScheduleStream = ref.watch(weeklyScheduleStreamProvider);

  return WeeklyScheduleNotifier(
    weeklyScheduleRepository,
    data: weeklyScheduleStream.hasValue
        ? Right(weeklyScheduleStream.value!)
        : Left(Exception(weeklyScheduleStream.error)),
  );
});
