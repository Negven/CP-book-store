import 'package:client/utils/convert_utils.dart';
import 'package:flutter/material.dart';

// Поля для Dto
class DtoF {
  final id = "id"; // ID
}

// Абстрактний клас для Dto
abstract class Dto implements Id {

  static final f = DtoF(); // Поля

  @override
  int? id; // ID

  @mustCallSuper
  // Метод десеріалізації з JSON
  fromJson(Json json) {
    id = json[f.id]; // Отримання ID
  }

  // Створення JSON об'єкту
  Json createJson() {
    Json json = {};
    if (id != null) {
      json[f.id] = id; // Додавання ID
    }
    return json;
  }
}
