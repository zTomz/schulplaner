extension DurationExtension on Duration {
  Map<String, dynamic> toMap() {
    return {
      'days': inDays,
      'hours': inHours.remainder(24),
      'minutes': inMinutes.remainder(60),
      'seconds': inSeconds.remainder(60),
      'milliseconds': inMilliseconds.remainder(1000),
      'microseconds': inMicroseconds.remainder(1000),
    };
  }
}

Duration durationFromMap(Map<String, dynamic> map) {
  return Duration(
    days: int.tryParse(map['days'].toString()) ?? 0,
    hours: int.tryParse(map['hours'].toString()) ?? 0,
    minutes: int.tryParse(map['minutes'].toString()) ?? 0,
    seconds: int.tryParse(map['seconds'].toString()) ?? 0,
    milliseconds: int.tryParse(map['milliseconds'].toString()) ?? 0,
    microseconds: int.tryParse(map['microseconds'].toString()) ?? 0,
  );
}