import 'dart:convert';

import 'package:client/utils/convert_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

Future<StorageService> initStorageService() async {

  if (await GetStorage.init()) {
    return StorageService(GetStorage());
  }

  throw "Storage not initialized";
}

class StorageService extends GetxService {

  final Logger _logger = Logger((StorageService).toString());

  final GetStorage _box;

  StorageService(this._box);

  dynamic getValue(String key, dynamic defaultValue, dynamic Function(dynamic value)? converter) {
    String? value = _box.read(key);
    if (defaultValue is String) {
      return value ?? defaultValue;
    } else {
      return value == null ? defaultValue : converter!(value);
    }
  }

  Object setValue(String key, dynamic value, dynamic defaultValue) {

    value ??= defaultValue;

    if (value is Enum) {
      _box.write(key, value.name);
    } else if (value is String) {
      _box.write(key, value);
    } else {
      throw "Unknown type of $key for $value";
    }

    _logger.info("Key $key set to $value");

    return value;
  }

  String setJson(String key, Json json) {
    final encoded = jsonEncode(json);
    return setValue(key, encoded, "{}") as String;
  }

  Json getJson(String key) {
    final encoded = getValue(key, "{}", null);
    return jsonDecode(encoded);
  }

  String setJsonList(String key, List<Json>? json) {
    final encoded = jsonEncode(json ?? []);
    return setValue(key, encoded, "[]") as String;
  }

  List<Json> getJsonList(String key) {
    final encoded = getValue(key, "[]", null);
    final List<dynamic> list = jsonDecode(encoded);
    return list.map((v) => v as Json).toList();
  }

}
