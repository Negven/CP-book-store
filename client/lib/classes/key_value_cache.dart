// Клас KeyValueCache для кешування значень, пов'язаних з ключами
class KeyValueCache<E, V> {

  // Приватна змінна для зберігання кешованих даних
  final Map<E, V> _cache = <E, V>{};

  // Функція, яка генерує значення для заданого ключа
  final V Function(E key) producer;

  // Конструктор класу
  KeyValueCache(this.producer);

  // Метод для отримання значення з кешу
  V get(E key) {
    // Перевірка, чи є значення в кеші
    if (!_cache.containsKey(key)) {
      // Додавання значення до кешу
      _cache[key] = producer(key);
    }
    // Повернення значення з кешу
    return _cache[key]!;
  }
}
