

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


class AParamsMap<T> extends DelegatingMap<String, T> {

  final Map<String, T> _map;
  AParamsMap(this._map) : super(_map);

  @override
  bool operator ==(Object other) {

    if (other is AParamsMap) {
      return mapEquals(this, other);
    }

    throw "Impossible to compare";
  }

  @override
  int get hashCode => _map.hashCode;

}


class DynamicParams extends AParamsMap<dynamic> {
  DynamicParams(super.map);
  DynamicParams.empty() : this(<String, dynamic>{});
}

class StringParams extends AParamsMap<dynamic> {
  StringParams(super.map);
  StringParams.empty() : this(<String, dynamic>{});
}
