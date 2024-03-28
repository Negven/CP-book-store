

import 'package:client/utils/call_utils.dart';
import 'package:client/utils/duration_utils.dart';
import 'package:flutter/material.dart';

class DefaultScrollController extends ScrollController {


  Future<void> scrollTo(double offset) {
    return super.animateTo(offset, duration: ScrollUtils.slow, curve: ScrollUtils.curve);
  }



}


abstract class ScrollUtils {

  static const slow = DurationUtils.slow;
  static const fast = DurationUtils.fast;
  static const curve = Curves.fastOutSlowIn;
  static const centerAlignment = 0.5;  // 0.5 - center of view list


  static DefaultScrollController createController() => DefaultScrollController();

  static scrollSlowTo(BuildContext? context) {
    if (context != null) {
      Scrollable.ensureVisible(context, duration: slow, curve: curve);
    }
  }

  static scrollFastTo(BuildContext? context) {
    if (context != null) {
      Scrollable.ensureVisible(context, duration: fast, curve: curve);
    }
  }

  static animateTo(ScrollController scrollController, double offset, [int retry = 0]) {

    if (scrollController.hasClients) {
      return scrollController.animateTo(offset, duration: fast, curve: curve);
    }

    if (retry < 3) {
      CallUtils.timeout(() => animateTo(scrollController, offset, retry + 1), 100);
    }
  }

}