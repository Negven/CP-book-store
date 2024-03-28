
import 'package:client/classes/utilizable.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';


abstract class UtilizableState<T extends StatefulWidget> extends State<T> with Utilizables, Utilizable implements IUtilizable {

  @override
  void dispose() {
    super.dispose();
    utilize();
  }

}

abstract class UtilizableClass with Utilizables, Utilizable implements IUtilizable {

}


class _RxState<V> with ListenableMixin, ListNotifierMixin, StateMixin<V>, Utilizable {

  setState(V? newState, RxStatus status) {
    change(newState, status: status);
  }

  @override
  void utilize() {
    super.utilize();
    dispose();
  }
}


abstract class UtilizableRxState<T extends StatefulWidget, V> extends UtilizableState<T> {

  late final _state = u(_RxState<V>());

  Widget obx(NotifierBuilder<V?> widget, {  Widget Function(String? error)? onError,  Widget? onLoading,  Widget? onEmpty}) {
    return _state.obx(widget, onError: onError, onLoading: onLoading, onEmpty: onEmpty);
  }

  V? get state => _state.state;
  RxStatus get status => _state.status;

  change(V? newState, RxStatus status) {
    _state.setState(newState, status);
  }

  // To show loading screen at least for 300 ms
  // To show success screen at for least 2 sec
  delayedSuccess(V successState, Function() delayed) {
    CallUtils.timeout(() => change(successState, RxStatus.success()), 300); // showing loading
    CallUtils.timeout(delayed, 2300);
  }


}


typedef U = T Function<T>(T);

class Autowire extends StatefulWidget {

  final Function(U u) onInit;
  const Autowire(this.onInit, {super.key});

  @override
  State<StatefulWidget> createState() => _AutowireState();
}

class _AutowireState extends UtilizableState<Autowire> {

  @override
  void initState() {
    super.initState();
    widget.onInit(u);
  }

  @override
  Widget build(BuildContext context) => Empty.instance;

}