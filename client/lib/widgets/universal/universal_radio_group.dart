
import 'package:client/classes/sizes.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../font_icon.dart';

class UniversalRadioGroup<T extends Enum> extends StatelessWidget {

  final List<UniversalRadioItem<T>> items;
  final UniversalController<UniversalRadioItem> controller;
  final Widget Function(UniversalRadioItem<T> item, void Function() onTap) toRadio;
  final int columns;
  final SizeVariant gap;

  static Widget toDefaultRadio(UniversalRadioItem item, void Function() onTap) =>
    UniversalButton(
      icon: item.icon,
      text: item.title,
      type: item.selected ? SurfaceType.filled : SurfaceType.outlined,
      onPressed: onTap,
    );

  const UniversalRadioGroup({
    super.key,
    required this.items,
    required this.controller,
    this.columns = 1,
    this.gap = SizeVariant.base,
    this.toRadio = UniversalRadioGroup.toDefaultRadio
  });

  void onPressed(UniversalRadioItem<T> item) {
    controller.value = item;
  }

  @override
  Widget build(BuildContext context) {
    List<List<UniversalRadioItem<T>>> sampleData = items.slices(columns).toList();
    return Obx(() {
      var rows = sampleData.map((rowData) {
        List<Widget> row = [];
        for(var item in rowData) {
          item.selected = controller.value == item.value;
          row.add(Expanded(child: toRadio(item, () => onPressed(item))));
        }
        return Space.row(
          size: gap,
          children: row,
        );
      }).toList();
      return  Space.column(
        size: gap,
        children: rows,
      );
    });
  }
}



class UniversalRadioItem<T extends Enum> extends UniversalItem<T> {
  FontIcon? icon;

  UniversalRadioItem(super.value, this.icon, title) {
    super.title = title;
  }
}