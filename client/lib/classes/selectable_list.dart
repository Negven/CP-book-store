


import 'dart:math';

class SelectableList<T> {

  final List<T> list;
  final int index;
  const SelectableList(this.list, {int? index})
      : index = index != null ?
          (list.length > index ? index : -1) :
          (list.length > 0 ? 0 : -1)
      ;

  int get length => list.length;

  T at(int index) {
    return list[index];
  }

  int scrollIndex(int itemsToShow) {
    return max(0, index - itemsToShow ~/ 2);
  }

  SelectableList<T> copyWith({List<T>? list, int? index}) {
    return SelectableList<T>(list ?? this.list, index: index ?? this.index);
  }

  SelectableList<T> nextIndex() {

    if (index + 1 < list.length) {
      return copyWith(index: index + 1);
    }

    if (list.isNotEmpty) {
      return copyWith(index: 0);
    }

    return this;
  }

  SelectableList<T> previousIndex() {

    if (index - 1 >= 0) {
      return copyWith(index: index - 1);
    } else if (list.isNotEmpty) {
      return copyWith(index: list.length - 1);
    }

    return this;
  }

  T? get selected => index >= 0 ? list[index] : null;

  @override
  bool operator ==(Object other) =>
      other is SelectableList<T> &&
          other.runtimeType == runtimeType &&
          other.index == index &&
          other.list.length == list.length;

  @override
  int get hashCode => Object.hash(list, index);
}
