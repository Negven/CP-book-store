import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

// Клас, який представляє елемент, який може бути вставлений у сітку.
abstract class InGrid {
  TrackSize get inGridSize; // розмір в сітці
}

// Простір у сітці.
class GridSpace extends StatelessWidget implements InGrid {
  const GridSpace({Key? key});

  @override
  Widget build(BuildContext context) => Empty.instance; // пустий віджет

  @override
  TrackSize get inGridSize => const FlexibleTrackSize(1.0); // гнучкий розмір
}

// Абстрактний клас сітки.
abstract class Grid {
  // Створення рядка у сітці.
  static LayoutGrid row({double? gap, GridFit? gridFit, required List<Widget> children}) =>
      _build(true, gap: gap, gridFit: gridFit, children: children);

  // Створення стовпця у сітці.
  static LayoutGrid column({double? gap, GridFit? gridFit, required List<Widget> children}) =>
      _build(false, gap: gap, gridFit: gridFit, children: children);

  // Функція побудови сітки.
  static LayoutGrid _build(bool inRow, {double? gap, GridFit? gridFit, required List<Widget> children}) {
    // Отримання розмірів дітей.
    final sizes = children.map((w) => w is InGrid ? (w as InGrid).inGridSize : auto).toList();
    final rowSizes = inRow ? [auto] : sizes; // розміри рядка
    final columnSizes = inRow ? sizes : [auto]; // розміри стовпця

    return LayoutGrid(
      gridFit: gridFit ?? GridFit.expand, // вирівнювання сітки
      rowGap: inRow ? null : gap, // проміжок між рядками
      columnGap: inRow ? gap : null, // проміжок між стовпцями
      columnSizes: columnSizes, // розміри стовпця
      rowSizes: rowSizes, // розміри рядка
      children: children, // діти
    );
  }
}
