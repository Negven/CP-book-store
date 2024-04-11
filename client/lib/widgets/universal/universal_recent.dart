import 'dart:math';

import 'package:client/classes/sizes.dart';
import 'package:client/service/_services.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:client/widgets/universal/universal_icon.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';





class UniversalRecent<T extends Object> extends StatelessWidget {

  static const defaultLimit = 7;
  final List<UniversalItem<T>> recent;

  const UniversalRecent({super.key, required this.recent});

  @override
  Widget build(BuildContext context) {

    if (this.recent.isEmpty) throw "Empty recent items";

    final children = <Widget>[
      FontIcon.recentlyUsed.fontIcon(size: SizeVariant.md, color: context.colors.text)
    ];

    for (var recent in this.recent) {
      children.add(
        ActionChip(
            label: Text(recent.title),
            onPressed: () => UniversalFieldContext.closeWith(context, recent)
        )
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: sizes.paddingV.sm,
      runSpacing: sizes.paddingV.sm,
      children: children,
    );
  }

  static void storeRecent<T extends Object>(String storeKey, UniversalItem<T> item, Serializer<T> serializer, {int limit = defaultLimit}) {

    final List<Json> list = Services.storage.getJsonList(storeKey);
    list.insert(0, item.toJson(serializer));
    if (list.length > limit) {
      list.length = limit;
    }

    Services.storage.setJsonList(storeKey, list);
  }

  static List<I> loadRecent<T extends Object, I extends UniversalItem<T>>(String? storeKey, Deserializer<T>? deserializer, I Function(Json, T) fromJson, {
    List<T>? fixedValues,
    Map<T, I>? itemsMap,
    int limit = defaultLimit
  }) {


    List<I> recent = [];

    final used = <T>{};
    if (storeKey != null && deserializer != null) {

      final List<Json> list = Services.storage.getJsonList(storeKey);
      for (var json in list) {

        final value = UniversalItem.valueFromJson(json, deserializer);

        if (used.contains(value)) continue;
        used.add(value);

        final item = itemsMap != null && itemsMap.containsKey(value) ? itemsMap[value] : fromJson(json, value);
        recent.add(item!);
      }
    }

    recent.length = min(recent.length, max(limit - ConvertUtils.length(fixedValues), 1));

    if (fixedValues != null && itemsMap != null) {
      for (var value in fixedValues) {
        if (!used.contains(value) && itemsMap.containsKey(value)) {
          recent.add(itemsMap[value]!);
        }
      }
    }

    return recent;
  }


}