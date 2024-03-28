

import 'dart:convert';

import '../../utils/convert_utils.dart';
import 'package:flutter/services.dart' show rootBundle;


class JsonAsset<T> {

  final String name;
  final T Function(Json) mapper;
  JsonAsset({required this.name, required this.mapper });

  Future<T> load() => rootBundle
      .loadString("assets/json/$name.json")
      .then((value) => mapper(jsonDecode(value)));

}

