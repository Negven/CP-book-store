
import 'package:get/get.dart';

typedef Initializer<T> = T Function();

class Lazy<T> {

  final Initializer<T> _initializer;
  Lazy(Initializer<T> initializer) : _initializer = initializer;

  Lazy.find() : this(() => Get.find<T>());

  T? _value;
  T get value  {

    if (isInitialized) {
      return _value!;
    }

    return _value = _initializer();
  }

  bool get isInitialized => _value != null;

}
