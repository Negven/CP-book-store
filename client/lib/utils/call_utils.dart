

import 'dart:async';

import 'package:get/get.dart';


abstract class CallUtils {

  static Future<dynamic> defer(dynamic f) {
    return Future.delayed(const Duration(milliseconds: 1), f);
  }

  static Future<dynamic> timeout(dynamic f, int milliseconds) {
    return Future.delayed(Duration(milliseconds: milliseconds), f);
  }

  static onNextFrame(Function() f) {
    Get.engine.addPostFrameCallback((timeStamp) {
      f.call();
    });
  }

}

