import 'package:flutter/material.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/days_header.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

class Timetable extends StatelessWidget {
  final WeeklyScheduleData weeklyScheduleData;

  const Timetable({
    super.key,
    required this.weeklyScheduleData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyScheduleDaysHeader(
          onWeekTapped: () {},
          timeColumnWidth: 100,
          week: Week.all,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              children: [
                Container(
                  width: 100,
                  color: Colors.red,
                  child: Column(
                    children: weeklyScheduleData.schoolLessons
                        .map((lesson) => Container(
                              height: 75,
                              width: 100,
                              alignment: Alignment.center,
                              color: Colors.blue,
                              child: Text(lesson.lesson.toString()),
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  width: 250,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
