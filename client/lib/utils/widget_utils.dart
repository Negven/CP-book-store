import 'dart:math';

import 'package:client/classes/sizes.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

// WidgetUtils - абстрактний клас, що містить утилітарні методи для роботи з віджетами.
abstract class WidgetUtils {
  static const int itemsToShow = 7;

  // maxItemToShowInModal - метод для обчислення максимальної кількості елементів, які можна показати в модальному вікні.
  static int maxItemToShowInModal([int itemsToShow = itemsToShow]) {
    final maxHeight = 70.vhR;
    final maxItemsToShow = maxHeight ~/ sizes.selectableTileHeight;
    return min(maxItemsToShow, itemsToShow);
  }

  // minModalContentSize - метод для обчислення мінімального розміру контенту модального вікна.
  static double minModalContentSize([int itemsToShow = itemsToShow]) => (maxItemToShowInModal() + 0.5) * sizes.selectableTileHeight; // NB! 0.5 to show possibility to scroll

  // selectAll - метод для вибору всього тексту в полі введення.
  static Function()? selectAll(TextEditingController controller) {
    return () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
  }

  // markNeedsBuildAll - метод для позначення всіх віджетів на побудову.
  static void markNeedsBuildAll(GlobalKey key) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    final current = key.currentContext;
    if (current != null) {
      (current as Element).visitChildren(rebuild);
    }
  }

  // markNeedsBuildAtLevel - метод для позначення віджетів на побудову на певному рівні.
  static void markNeedsBuildAtLevel(GlobalKey key, int level) {
    assert(level > 0);

    void rebuild(Element el, int currentLevel) {
      if (currentLevel == 0) {
        el.markNeedsBuild();
      } else {
        el.visitChildren((el) => rebuild(el, currentLevel - 1));
      }
    }

    final current = key.currentContext;
    if (current != null) {
      (current as Element).visitChildren((el) => rebuild(el, level));
    }
  }
}
