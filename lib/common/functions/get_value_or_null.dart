T? getValueOrNull<T>(T? input) {
  if (input is String && input.isEmpty) {
    return null;
  } else if (input is List && input.isEmpty) {
    return null;
  } else if (input is Map && input.isEmpty) {
    return null;
  } else if (input is Set && input.isEmpty) {
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
