import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/domain/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/state/weekly_schedule_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_future_provider.dart';

final weeklyScheduleProvider = StateNotifierProvider<WeeklyScheduleNotifier,
    Either<Exception, WeeklyScheduleData>>((ref) {
  final weeklyScheduleRepository = ref.watch(weeklyScheduleRepositoryProvider);
  final weeklyScheduleFuture = ref.watch(weeklyScheduleFutureProvider);

  return WeeklyScheduleNotifier(
    weeklyScheduleRepository: weeklyScheduleRepository,
    initialData: weeklyScheduleFuture.hasValue || weeklyScheduleFuture.isLoading
        ? Right(
            weeklyScheduleFuture.isLoading
                ? WeeklyScheduleData.empty()
                : weeklyScheduleFuture.value!,
          )
        : Left(Exception('Der Stundentplan konnte nicht geladen werden')),
  );
});
