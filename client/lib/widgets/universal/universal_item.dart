import 'package:client/enum/language_code.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/string_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

// Поля універсального елемента
class _UniversalItemFields {
  final value = 'value'; // Значення
  final title = 'title'; // Заголовок
  final subtitle = 'subtitle'; // Підзаголовок
  final searchable = 'searchable'; // Пошуковий запит
}

// Розширення для списку універсальних елементів
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

// Клас для універсального елемента
class UniversalItem<V extends Object> {
  static final f = _UniversalItemFields();

  final V value;
  String title = ""; // Заголовок
  String? subtitle; // Підзаголовок
  String? searchable; // Пошуковий запит
  bool selected = false; // Вибрано
  bool focused = false; // Сфокусовано

  UniversalItem(this.value);

  // Перетворення у JSON
  Json toJson(Serializer<V> serialize) {
    Json json = {};
    json[f.value] = serialize(value);
    json[f.title] = title;
    json[f.subtitle] = subtitle;
    json[f.searchable] = searchable;
    return json;
  }

  // Присвоєння властивостей
  void assignFrom(UniversalItem i) {
    title = i.title;
    subtitle = i.subtitle;
    searchable = i.searchable;
  }

  // Створення об'єкта з JSON
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

  // Пошук за запитом
  static List<I> search<I extends UniversalItem>(Iterable<I> iterable, String query) {
    final queryL = query.toLowerCase();
    return iterable.where((element) => StringUtils.containsIn(queryL, element.title, element.subtitle, element.searchable)).toList();
  }

  // Сортування за заголовком
  static List<I> sortByTitle<I extends UniversalItem>(List<I> items) {
    items.sortBy((i) => i.title);
    return items;
  }

  // Створення картотеки за значенням
  static Map<V, I> mapByValue<V extends Object, I extends UniversalItem<V>>(List<I> items) {
    final result = <V, I>{};
    for (var item in items) {
      result[item.value] = item;
    }
    return result;
  }

  // Локалізація елементів
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
