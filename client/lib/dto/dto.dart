

import 'package:client/utils/convert_utils.dart';
import 'package:flutter/material.dart';

class DtoF {
  final id = "id";
}

abstract class Dto implements Id {

  static final f = DtoF(); // fields

  @override
  int? id;

  @mustCallSuper
  fromJson(Json json) {
    id = json[f.id];
  }

  Json createJson() {
    Json json = {};
    if (id != null) {
      json[f.id] = id;
    }
    return json;
  }
}