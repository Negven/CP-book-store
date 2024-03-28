


import 'package:client/enum/language_code.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/string_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class _UniversalItemFields {
  final value = 'value';
  final title = 'title';
  final subtitle = 'subtitle';
  final searchable = 'searchable';
}

extension UniversalItemExtension<I extends UniversalItem> on List<I> {

  List<I> extendOn(I? item) {

    if (item == null || contains(item)) return this;

    final copy = List<I>.of(this);
    copy.insert(0, item);
    return copy;
  }

  I? selectBasedOn(I? item) {
    return item == null ? null : firstWhere((element) => element == item);
  }

}

class UniversalItem<V extends Object> {

  static final f = _UniversalItemFields();

  final V value;

  String title = "";
  String? subtitle;
  String? searchable;

  bool selected = false;
  bool focused = false;

  UniversalItem(this.value);

  Json toJson(Serializer<V> serialize) {
    Json json = {};
    json[f.value] = serialize(value);
    json[f.title] = title;
    json[f.subtitle] = subtitle;
    json[f.searchable] = searchable;
    return json;
  }

  void assignFrom(UniversalItem i) {
    title = i.title;
    subtitle = i.subtitle;
    searchable = i.searchable;
  }

  static V valueFromJson<V>(Json json, Deserializer<V> deserialize) {
    return deserialize(json[f.value]);
  }
  static I fromJson<I extends UniversalItem>(Json json, I item) {
    item.title = json[f.title]!;
    item.subtitle = json[f.subtitle];
    item.searchable = json[f.searchable];
    return item;
  }

  @override
  bool operator ==(Object other) {

    if (other is UniversalItem) {
      return value == other.value;
    }

    return value == other;
  }

  @override
  int get hashCode => value.hashCode;


  @override
  String toString() {
    return value.toString();
  }

  static List<I> search<I extends UniversalItem>(Iterable<I> iterable, String query) {
    final queryL = query.toLowerCase();
    return iterable.where((element) => StringUtils.containsIn(queryL, element.title, element.subtitle, element.searchable)).toList();
  }

  static List<I> sortByTitle<I extends UniversalItem>(List<I> items) {
    items.sortBy((i) => i.title);
    return items;
  }

  static Map<V, I> mapByValue<V extends Object, I extends UniversalItem<V>>(List<I> items) {
    final result = <V, I>{};
    for (var item in items) {
      result[item.value] = item;
    }
    return result;
  }

  static List<I> toLocalized<V extends Object, I extends UniversalItem<V>>(Json json,
      Iterable<V> Function(Json) toValues,
      I Function(V value) toItem, {bool hideInLocal = true}) {

    final isEn = LanguageCode.isEnNow;
    final Json localNames = json[LanguageCode.local]!;
    final Json enNames = json[LanguageCode.en.name]!;
    final Json tNames = json[LanguageCode.now.name]!;

    final list = <I>[];

    for (var value in toValues.call(enNames)) {

      final key = value.toString();
      try {
        final title = tNames[key]!.toString();

        final enName = enNames[key]!.toString();
        final localName = localNames[key]!.toString();

        final enSubName = !isEn && enName != title ? " $enName" : "";
        final localSubName = title != localName && enSubName != localName ? (isEn ? " $localName" : " ($localName)") : "";

        // NB! web optimization to prevent loading a lot of fallback fonts
        final subtitle = "[$key]$enSubName${ kIsWeb || !hideInLocal ? "" : localSubName }";
        final searchable = "[$key]$enSubName$localSubName";


        final item = toItem(value);
        item.title = title;
        item.subtitle = subtitle;
        item.searchable = searchable;
        list.add(item);
      } catch (e) {
        debugPrint("missing: $key");
      }
    }

    return list;
  }

}
