

class Comparators<T> {

  final List<dynamic Function(T)> comparators;
  const Comparators(this.comparators);

  int compare(T a, T b) {

    for (var c in comparators) {

      final ca = c.call(a);
      final cb = c.call(b);

      if (ca != null && cb != null) {
        final result = ca.compareTo(cb);
        if (result != 0) return result;
      } else if (ca != null && cb == null) {
        return 1;
      } else if (ca == null && cb != null) {
        return -1;
      }

    }

    return 0;
  }

}