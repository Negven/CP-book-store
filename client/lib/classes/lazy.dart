import 'package:get/get.dart';

// Тип даних для функції-ініціалізатора
typedef Initializer<T> = T Function();

// Клас для отримання значення
class Lazy<T> {

  // Ініціалізатор для створення значення типу T
  final Initializer<T> _initializer;
  Lazy(Initializer<T> initializer) : _initializer = initializer;

  // Конструктор для пошуку залежності типу T через Get.find
  Lazy.find() : this(() => Get.find<T>());

  T? _value;

  // Отримання значення. Якщо значення не ініціалізовано, викликає ініціалізатор.
  T get value  {
    if (isInitialized) {
      return _value!;
    }

    return _value = _initializer();
  }

  // Перевірка чи значення ініціалізовано
  bool get isInitialized => _value != null;

}
