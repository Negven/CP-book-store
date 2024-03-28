

import 'dart:async';

import 'package:get/get.dart';


abstract class CallUtils {

  static Future<dynamic> defer(dynamic f) {
    return Future.delayed(const Duration(milliseconds: 1), f); // NB! Must be 1 as 0 can be postponed by optimization
  }

  static Future<dynamic> timeout(dynamic f, int milliseconds) {
    return Future.delayed(Duration(milliseconds: milliseconds), f); // NB! Must be 1 as 0 can be postponed by optimization
  }

  static void callAsNotNull<T>(T? Function() getter, void Function(T) f, {int maxAwaitingCycles = 500, int? delayBeforeCall}) {

    cycle() {
      T? v = getter.call();
      if (v != null) {
        if (delayBeforeCall == null) {
          f.call(v);
        } else {
          timeout(() => f.call(v), delayBeforeCall);
        }
      } else {
        if (maxAwaitingCycles-- > 0) defer(cycle);
      }
    }

    defer(cycle);
  }

  static onNextFrame(Function() f) {
    Get.engine.addPostFrameCallback((timeStamp) {
      f.call();
    });
  }

}

