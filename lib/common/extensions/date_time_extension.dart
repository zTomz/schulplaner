import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/time.dart';

extension DateTimeExtension on DateTime {
  String get monthString {
    switch (month) {
      case 1:
        return "Januar";
      case 2:
        return "Februar";
      case 3:
        return "März";
      case 4:
        return "April";
      case 5:
        return "Mai";
      case 6:
        return "Juni";
      case 7:
        return "Juli";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "Oktober";
      case 11:
        return "November";
      case 12:
        return "Dezember";
      default:
        return "Unbekannt";
    }
  }

  /// Compares only [day], [month] and [year] of [DateTime]. Optional a repeating type can be
  /// added
  bool compareWithoutTime(DateTime date, {RepeatingEventType? repeatingType}) {
    if (repeatingType != null) {
      switch (repeatingType) {
        case RepeatingEventType.daily:
          return true;
        case RepeatingEventType.weekly:
          return weekday == date.weekday;
        case RepeatingEventType.monthly:
          return day == date.day;
        case RepeatingEventType.yearly:
          return day == date.day && month == date.month;
      }
    }

    return day == date.day && month == date.month && year == date.year;
  }

  /// Returns The List of date of Current Week, all of the dates will be without
  /// time.
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> datesOfWeek({Weekday start = Weekday.monday}) {
    // Here %7 ensure that we do not subtract >6 and <0 days.
    // Initial formula is,
    //    difference = (weekday - startInt)%7
    // where weekday and startInt ranges from 1 to 7.
    // But in WeekDays enum index ranges from 0 to 6 so we are
    // adding 1 in index. So, new formula with WeekDays is,
    //    difference = (weekdays - (start.index + 1))%7
    //
    final startDay = DateTime(
      year,
      month,
      day - (weekday - start.index - 1) % 7,
    );

    return [
      startDay,
      DateTime(startDay.year, startDay.month, startDay.day + 1),
      DateTime(startDay.year, startDay.month, startDay.day + 2),
      DateTime(startDay.year, startDay.month, startDay.day + 3),
      DateTime(startDay.year, startDay.month, startDay.day + 4),
      DateTime(startDay.year, startDay.month, startDay.day + 5),
      DateTime(startDay.year, startDay.month, startDay.day + 6),
    ];
  }

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month
  /// can have.
  List<DateTime> datesOfMonths({Weekday startDay = Weekday.monday}) {
    final monthDays = <DateTime>[];
    for (var i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays.addAll(
        DateTime(year, month, start).datesOfWeek(start: startDay),
      );
    }
    return monthDays;
  }
}
