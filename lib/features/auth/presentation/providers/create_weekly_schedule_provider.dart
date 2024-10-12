import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/presentation/providers/state/create_weekly_schedule_notifier.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

final createWeeklyScheduleProvider =
    StateNotifierProvider<CreateWeeklyScheduleNotifier, WeeklyScheduleData>(
  (ref) => CreateWeeklyScheduleNotifier(),
);
