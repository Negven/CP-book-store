

import 'dart:async';

import 'package:client/classes/utilizable.dart';
import 'package:get/get.dart';


class DebounceValue<V> with Utilizables, Utilizable implements IUtilizable {

  final Duration duration;
  Timer? _timer;
  V _value;
  late Rx<V> _valueRx;

  DebounceValue(this._value, Function(V) callback, {this.duration = const Duration(milliseconds: 300)}) {

    u(cancel);

    _valueRx = u(Rx<V>(_value));
    _valueRx.listen(callback);
  }

  updateValue() {
    _valueRx.value = _value;
  }

  setValue(V value) {
    _value = value;
    cancel();
    _timer = Timer(duration, updateValue);
  }

  cancel() {
    _timer?.cancel();
  }

}