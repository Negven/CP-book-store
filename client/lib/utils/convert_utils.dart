import 'dart:convert';
import 'dart:typed_data';

import 'package:client/utils/string_utils.dart';

// Типи для обробки JSON
typedef Json = Map<String, dynamic>;
typedef FromJson<T> = T Function(Json);

// Серіалізатори та десеріалізатори
typedef Serializer<T> = dynamic Function(T);
typedef Deserializer<T> = T Function(dynamic);

// Абстрактний клас ідентифікатора
abstract class Id {
  int? get id;
}

// Абстрактний клас унікального ідентифікатора
abstract class Uid {
  String? get uid;
}

// Абстрактний клас для перетворення в JSON
abstract class ToJson {
  Json toJson();
}

// Утиліти для конвертації
abstract class ConvertUtils {

  // Парсер для цілих чисел
  static int? nParseInt(dynamic value) {
    if (value == null) return null;
    return rParseInt(value);
  }

  static int rParseInt(dynamic value) {
    assert(value != null);
    if (value is String) return int.parse(value);
    return value as int;
  }

  // Парсер для булевих значень
  static bool? nParseBool(dynamic value) {
    if (value == null) return null;
    return rParseBool(value);
  }

  static bool rParseBool(dynamic value) {
    assert(value != null);
    if (value is String) return (value == 'True' || value == 'true');
    if (value is int) return value == 1;
    return value as bool;
  }

  // Форматування булевих значень
  static String? nFormatBool(bool? value) {
    if (value == null) return null;
    return rFormatBool(value);
  }

  static String rFormatBool(bool value) {
    return value ? 'True' : 'False';
  }

  // Парсер для енумів
  static T rParseEnum<T extends Enum>(Iterable<T> values, String str) {
    return values.byName(str);
  }

  static T? nParseEnum<T extends Enum>(Iterable<T> values, String? str) {

    if (str == null) return null;

    for (var value in values) {
      if (value.name == str) return value;
    }

    return null;
  }

  // Перетворення об'єктів в JSON
  static List<Json> toJson<T extends ToJson>(Iterable<T>? items) {

    final jsons = <Json>[];

    if (items != null && items.isNotEmpty) {
      for (var item in items) {
        jsons.add(item.toJson());
      }
    }

    return jsons;
  }

  // Перетворення JSON рядка в об'єкт
  static T fromJsonStr<T>(String source, FromJson<T> fromJson) {
    final Json json = jsonDecode(source);
    return fromJson(json);
  }

  // Перетворення списку об'єктів в JSON рядок
  static String toJsonListStr<T extends ToJson>(Iterable<T>? items) {
    return jsonEncode(toJson(items));
  }

  // Парсинг JSON рядка у список об'єктів
  static List<T> fromJsonListStr<T extends ToJson>(String source,  FromJson<T> fromJson) {

    if (source.isEmpty) return [];

    List<dynamic> jsons = jsonDecode(source);

    var result = <T>[];
    if (jsons.isEmpty) return result;

    for (var json in jsons) {
      result.add(fromJson(json as Json));
    }

    return result;
  }

  // Заповнення мапи ідентифікаторів
  static Map<int, T> fillMap<T extends Id>(Map<int, T> result, Iterable<T>? items) {

    if (items != null) {
      for (var item in items) {
        result[item.id!] = item;
      }
    }

    return result;
  }

  static Map<String, T> fillMapUid<T extends Uid>(Map<String, T> result, Iterable<T>? items) {

    if (items != null) {
      for (var item in items) {
        result[item.uid!] = item;
      }
    }

    return result;
  }

  // Перетворення списку в мапу
  static Map<int, T> toMap<T extends Id>(Iterable<T>? items) {
    return fillMap(<int, T>{}, items);
  }

  static Map<String, T> toMapUid<T extends Uid>(Iterable<T>? items) {
    return fillMapUid(<String, T>{}, items);
  }

  // Отримання першого ідентифікатора
  static int? firstId<T extends Id>(Iterable<T>? items) {
    return items == null || items.isEmpty ? null : items.first.id;
  }

  static String? firstUid<T extends Uid>(Iterable<T>? items) {
    return items == null || items.isEmpty ? null : items.first.uid;
  }

  // Сортування списку
  static List<T> sort<T>(Iterable<T>? items) {
    if ( items == null || items.isEmpty ) return [];
    final result = items.toList();
    result.sort();
    return result;
  }

  // Злиття двох байтових масивів
  static Uint8List concat(Uint8List a, [Uint8List? b, Uint8List? c]) {
    var result = BytesBuilder();
    result.add(a);
    if (b != null) result.add(b);
    if (c != null) result.add(c);
    return result.toBytes();
  }

  // Об'єднання унікальних мап
  static Map<String, String> mergeUnique(Iterable<Map<String, String>> maps) {
    final result = <String, String>{};
    for (var map in maps) {
      map.forEach((key, value) {
        if (result.containsKey(key)) throw "Not unique key: $key";
        result[key] = value;
      });
    }
    return result;
  }

  // Перевірка чи всі аргументи не пусті
  static bool everyNotEmpty(List<dynamic> args) {
    return args.every((el) {
      if (el == null) return false;
      if (el is String) return StringUtils.isNotEmpty(el);
      if (el is Iterable) return el.isNotEmpty;
      return el != null;
    });
  }

  // Перевірка чи є хоча б один пустий аргумент
  static bool anyIsEmpty(List<dynamic> args)
  => !everyNotEmpty(args);

  // Створення мапи
  static mapFrom<T, V>(Iterable<T> values, V Function(T) convert) {
    final result = <T, V>{};
    for (var value in values) {
      result[value] = convert.call(value);
    }
    return result;
  }

  // Отримання довжини списку
  static int length(List? list) => list == null ? 0 : list.length;

  // Розділення рядка на частини
  static List<String> splitString(String input, int chunkSize) {

    final List<String> chunks = [];

    for (int i = 0; i < input.length; i += chunkSize) {
      if (i + chunkSize <= input.length) {
        chunks.add(input.substring(i, i + chunkSize));
      } else {
        chunks.add(input.substring(i));
      }
    }

    return chunks;
  }
}
