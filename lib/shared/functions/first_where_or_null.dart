/// Iterate over a list, when it catches an item that satisfies the given `test()` function
/// it will return this item. If it finds nothing, it will return `null`.
T? firstWhereOrNull<T>(
  Iterable<T> iterable,
  bool Function(T element) test,
) {
  for (final T element in iterable) {
    if (test(element)) {
      return element;
    }
  }
  return null;
}
