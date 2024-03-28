
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


abstract class IUtilizable {
  bool get utilized;
  set utilized(bool value);
  void utilize();
}

mixin Utilizable implements IUtilizable {

  bool _utilized = false;

  @override
  bool get utilized => _utilized;

  @override
  set utilized(bool value) => _utilized = value;

  @override
  @mustCallSuper
  void utilize() {

    utilized = true;

    if (this is Utilizables) {
      (this as Utilizables).autoUtilize();
    }
  }

}

mixin Utilizables {

  final List<Function()> _utilizables = [];

  T u<T>(T disposable) {

    if (disposable != null) {

      if (disposable is StreamSubscription<dynamic>) {
        _utilizables.add(() => disposable.cancel());
      } else if (disposable is ChangeNotifier) {
        _utilizables.add(disposable.dispose);
      } else if (disposable is IUtilizable) {
        _utilizables.add(disposable.utilize);
      } else if (disposable is Rx) {
        _utilizables.add(disposable.close);
      } else if (disposable is RxList) {
        _utilizables.add(disposable.close);
      } else if (disposable is Function()) {
        _utilizables.add(disposable);
      } else {
        throw 'Unknown type: $disposable';
      }
    }

    return disposable;
  }

  autoUtilize () {

    final copy = [..._utilizables.reversed];
    _utilizables.length = 0;

    for (var element in copy) {
      try {
        element.call();
      } catch (e, st) {
        debugPrintStack(stackTrace: st, label: e.toString());
      }
    }
  }

}
