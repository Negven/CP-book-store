
import 'package:flutter/material.dart';

class NavigatorSimpleObserver extends NavigatorObserver {

  final Function() _listener;

  NavigatorSimpleObserver(this._listener);

  @override
  void didPop(Route route, Route? previousRoute) {
    _listener.call();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _listener.call();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _listener.call();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _listener.call();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    _listener.call();
  }

  @override
  void didStopUserGesture() {
    _listener.call();
  }

}
