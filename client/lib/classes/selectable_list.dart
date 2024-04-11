import 'dart:math';

// Клас для представлення списку з можливістю вибору елементів
class SelectableList<T> {
  // Внутрішній список елементів
  final List<T> list;

  // Індекс поточного вибраного елемента
  final int index;

  // Конструктор класу SelectableList
  const SelectableList(this.list, {int? index})
      : index = index != null
      ? (list.length > index ? index : -1) // Перевірка індексу на валідність
      : (list.length > 0 ? 0 : -1); // Визначення початкового індексу

  // Отримання довжини списку
  int get length => list.length;

  /// Отримання елемента за індексом
  T at(int index) {
    return list[index];
  }

  /// Розрахунок індексу для прокручування, щоб вибраний елемент був центрований
  int scrollIndex(int itemsToShow) {
    final halfItemsToShow = itemsToShow ~/ 2; // Отримання половини кількості елементів для відображення
    return max(0, index - halfItemsToShow); // Забезпечення невід'ємного значення індексу прокручування
  }

  /// Створення копії списку з можливістю оновлення елементів або індексу
  SelectableList<T> copyWith({List<T>? list, int? index}) {
    return SelectableList<T>(list ?? this.list, index: index ?? this.index);
  }

  /// Перехід до наступного елемента в списку
  SelectableList<T> nextIndex() {
    if (index + 1 < list.length) {
      return copyWith(index: index + 1);
    } else if (list.isNotEmpty) {
      return copyWith(index: 0); // Циклічний перехід на початок списку
    } else {
      return this; // Повернення поточного стану, якщо список порожній
    }
  }

  /// Перехід до попереднього елемента в списку
  SelectableList<T> previousIndex() {
    if (index - 1 >= 0) {
      return copyWith(index: index - 1);
    } else if (list.isNotEmpty) {
      return copyWith(index: list.length - 1); // Циклічний перехід в кінець списку
    } else {
      return this; // Повернення поточного стану, якщо список порожній
    }
  }

  /// Отримання поточного вибраного елемента (null, якщо немає вибору)
  T? get selected => index >= 0 ? list[index] : null;

  /// Оператор порівняння для перевірки рівності двох об'єктів SelectableList
  @override
  bool operator ==(Object other) =>
      other is SelectableList<T> &&
          other.runtimeType == runtimeType &&
          other.index == index &&
          other.list.length == list.length;

  /// Отримання хеш-коду об'єкта
  @override
  int get hashCode => Object.hash(list, index);
}
