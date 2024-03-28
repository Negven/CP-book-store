

import 'dart:math';

import 'package:client/classes/sizes.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

abstract class WidgetUtils {

  static List<Widget> toChildren([List<Widget?>? children]) {
      if (children == null) return [];
      return children.whereNotNull().toList();
  }

  static const int itemsToShow = 7;

  static int maxItemToShowInModal([int itemsToShow = itemsToShow]) {
    final maxHeight = 70.vhR;
    final maxItemsToShow = maxHeight ~/ sizes.selectableTileHeight;
    return min(maxItemsToShow, itemsToShow);
  }

  static double minModalContentSize([int itemsToShow = itemsToShow]) => (maxItemToShowInModal() + 0.5) * sizes.selectableTileHeight; // NB! 0.5 to show possibility to scroll

  static Function()? selectAll(TextEditingController controller) {
    return () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
  }

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

  static void markNeedsBuildAtLevel(GlobalKey key, int level) {
    assert(level > 0);

    void rebuild(Element el, int currentLevel) {
      if (currentLevel == 0) {
        el.markNeedsBuild();
      } else {
        el.visitChildren((el) => rebuild(el, currentLevel- 1));
      }
    }

    final current = key.currentContext;
    if (current != null) {
      (current as Element).visitChildren((el) => rebuild(el, level));
    }
  }
}