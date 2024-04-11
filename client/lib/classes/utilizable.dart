// Імпорт необхідних пакетів
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Абстрактний клас для об'єктів, що використовуються
abstract class IUtilizable {
  bool get utilized; // Повертає чи використаний об'єкт
  set utilized(bool value); // Встановлює статус використання об'єкта
  void utilize(); // Метод для використання об'єкта
}

// Міксін для використання об'єктів
mixin Utilizable implements IUtilizable {

  bool _utilized = false;

  @override
  bool get utilized => _utilized; // Повертає статус використання

  @override
  set utilized(bool value) => _utilized = value; // Встановлює статус використання

  @override
  @mustCallSuper
  void utilize() {

    utilized = true; // Встановлює статус використання як true

    if (this is Utilizables) {
      (this as Utilizables).autoUtilize(); // Автоматично використовує інші об'єкти, якщо це можливо
    }
  }

}

// Міксін для збереження та автоматичного використання об'єктів
mixin Utilizables {

  final List<Function()> _utilizables = []; // Список функцій для використання об'єктів

  T u<T>(T disposable) {

    if (disposable != null) {

      if (disposable is StreamSubscription<dynamic>) {
        _utilizables.add(() => disposable.cancel()); // Додає функцію для відписки від стріму
      } else if (disposable is ChangeNotifier) {
        _utilizables.add(disposable.dispose); // Додає функцію для видалення слухачів змін
      } else if (disposable is IUtilizable) {
        _utilizables.add(disposable.utilize); // Додає функцію для використання інших об'єктів
      } else if (disposable is Rx) {
        _utilizables.add(disposable.close); // Додає функцію для закриття Rx змінних
      } else if (disposable is RxList) {
        _utilizables.add(disposable.close);
      } else if (disposable is Function()) {
        _utilizables.add(disposable); // Додає інші функції
      } else {
        throw 'Unknown type: $disposable';
      }
    }

    return disposable;
  }

  autoUtilize () {

    final copy = [..._utilizables.reversed]; // Копіює список функцій
    _utilizables.length = 0; // Очищає список функцій

    for (var element in copy) {
      try {
        element.call(); // Викликає кожну функцію
      } catch (e, st) {
        debugPrintStack(stackTrace: st, label: e.toString()); // Виводить стек виклику у випадку помилки
      }
    }
  }

}
