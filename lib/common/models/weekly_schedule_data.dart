import 'dart:convert';

import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';

/// This class holds the data for the weekly schedule. It contains the time spans and the
/// lessons of the weekly schedule
class WeeklyScheduleData {
  final Set<TimeSpan> timeSpans;
  final List<Lesson> lessons;

  const WeeklyScheduleData({
    required this.timeSpans,
    required this.lessons,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeSpans': timeSpans.map((x) => x.toMap()).toList(),
      'lessons': lessons.map((x) => x.toMap()).toList(),
    };
  }

  factory WeeklyScheduleData.fromMap(Map<String, dynamic> map) {
    return WeeklyScheduleData(
      timeSpans: Set<TimeSpan>.from(map['timeSpans']?.map((x) => TimeSpan.fromMap(x))),
      lessons: List<Lesson>.from(map['lessons']?.map((x) => Lesson.fromMap(x))),
    );
  }


  factory WeeklyScheduleData.fromJson(String source) => WeeklyScheduleData.fromMap(json.decode(source));
}
