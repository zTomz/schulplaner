import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';

/// This class only holds the data from the [CreateWeeklySchedulePage], so it can
/// be passed to the next screen in the account creation flow
class CreateWeeklyScheduleData {
  final Set<TimeSpan> timeSpans;
  final List<Lesson> lessons;

  CreateWeeklyScheduleData({
    required this.timeSpans,
    required this.lessons,
  });
}