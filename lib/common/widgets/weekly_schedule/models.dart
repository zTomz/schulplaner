import 'package:equatable/equatable.dart';
import 'package:schulplaner/common/models/time.dart';

class SchoolTimeCell extends Equatable {
  final Weekday weekday;
  final TimeSpan timeSpan;

  const SchoolTimeCell({
    required this.weekday,
    required this.timeSpan,
  });

  @override
  List<Object?> get props => [weekday, timeSpan];
}

/// The gender.
enum Gender {
  male,
  female,
  divers;

  String get salutation {
    switch (this) {
      case Gender.male:
        return "Herr";
      case Gender.female:
        return "Frau";
      case Gender.divers:
        return "";
    }
  }

  String get gender {
    switch (this) {
      case Gender.male:
        return "Männlich";
      case Gender.female:
        return "Weiblich";
      case Gender.divers:
        return "Divers";
    }
  }

  static List<String> get gendersAsList => [
        "Männlich",
        "Weiblich",
        "Divers",
      ];

  static Gender fromString(String value) {
    switch (value) {
      case "Männlich":
        return Gender.male;
      case "Weiblich":
        return Gender.female;
      default:
        return Gender.divers;
    }
  }
}

/// An enum to represent the week. Either A or B or All
enum Week {
  a(name: "A"),
  b(name: "B"),
  all(name: "A & B");

  final String name;

  const Week({
    required this.name,
  });

  /// Returns the next week
  Week next() {
    switch (this) {
      case Week.a:
        return Week.b;
      case Week.b:
        return Week.all;
      case Week.all:
        return Week.a;
    }
  }
}
