

class KeyValueCache<E, V> {

  final Map<E, V> _cache = <E, V>{};
  final V Function(E key) producer;

  KeyValueCache(this.producer);

  V get(E key) {
    if (!_cache.containsKey(key)) {
      _cache[key] = producer(key);
    }
    return _cache[key]!;
  }
}