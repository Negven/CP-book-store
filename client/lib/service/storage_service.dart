import 'dart:convert';

import 'package:client/utils/convert_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

// Ініціалізувати сервіс зберігання
Future<StorageService> initStorageService() async {

  // Ініціалізувати GetStorage
  if (await GetStorage.init()) {
    return StorageService(GetStorage());
  }

  // Якщо GetStorage не ініціалізувався, викинути помилку
  throw "Storage not initialized";
}

// Сервіс зберігання
class StorageService extends GetxService {

  // Логер
  final Logger _logger = Logger((StorageService).toString());

  // Контейнер для зберігання даних
  final GetStorage _box;

  // Конструктор
  StorageService(this._box);

  // Отримати значення
  dynamic getValue(String key, dynamic defaultValue, dynamic Function(dynamic value)? converter) {
    String? value = _box.read(key);
    if (defaultValue is String) {
      return value ?? defaultValue;
    } else {
      return value == null ? defaultValue : converter!(value);
    }
  }

  // Встановити значення
  Object setValue(String key, dynamic value, dynamic defaultValue) {

    // Якщо значення не задане, встановити значення за замовчуванням
    value ??= defaultValue;

    // Якщо значення є перерахуванням, записати його як ім'я
    if (value is Enum) {
      _box.write(key, value.name);
    }
    // Якщо значення є рядком, записати його
    else if (value is String) {
      _box.write(key, value);
    }
    // Якщо тип значення невідомий, викинути помилку
    else {
      throw "Unknown type of $key for $value";
    }

    // Записати лог
    _logger.info("Key $key set to $value");

    return value;
  }

  // Зберегти JSON
  String setJson(String key, Json json) {
    final encoded = jsonEncode(json);
    return setValue(key, encoded, "{}") as String;
  }

  // Отримати JSON
  Json getJson(String key) {
    final encoded = getValue(key, "{}", null);
    return jsonDecode(encoded);
  }

  // Зберегти список JSON
  String setJsonList(String key, List<Json>? json) {
    final encoded = jsonEncode(json ?? []);
    return setValue(key, encoded, "[]") as String;
  }

  // Отримати список JSON
  List<Json> getJsonList(String key) {
    final encoded = getValue(key, "[]", null);
    final List<dynamic> list = jsonDecode(encoded);
    return list.map((v) => v as Json).toList();
  }

}
