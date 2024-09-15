T? getValueOrNull<T>(T? input) {
  if (T is String && (input as String).isEmpty) {
    return null;
  } else if (T is List && (input as List).isEmpty) {
    return null;
  } else if (T is Map && (input as Map).isEmpty) {
    return null;
  } else if (T is Set && (input as Set).isEmpty) {
    return null;
  }

  return input;
}

extension GetStringOrNullExtension on String {
  /// If the value is empty, it will null. Otherwise it will return the string as is.
  String? getStringOrNull({
    bool trim = true,
  }) {
    return getValueOrNull<String>(this.trim());
  }
}

extension GetListOrNullExtension on List {
  /// If the value is empty, it will null. Otherwise it will return the list as is.
  List? getListOrNull() {
    return getValueOrNull<List>(this);
  }
}

extension GetMapOrNullExtension on Map {
  /// If the value is empty, it will null. Otherwise it will return the map as is.
  Map? getMapOrNull() {
    return getValueOrNull<Map>(this);
  }
}

extension GetSetOrNullExtension on Set {
  /// If the value is empty, it will null. Otherwise it will return the set as is.
  Set? getSetOrNull() {
    return getValueOrNull<Set>(this);
  }
}
