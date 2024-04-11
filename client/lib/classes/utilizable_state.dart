import 'package:client/classes/utilizable.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

// Абстрактний клас для стану, який може бути використаний
abstract class UtilizableState<T extends StatefulWidget> extends State<T> with Utilizables, Utilizable implements IUtilizable {

  @override
  void dispose() {
    super.dispose();
    utilize(); // Використання ресурсів під час видалення стану
  }

}

// Абстрактний клас, який може бути використаний
abstract class UtilizableClass with Utilizables, Utilizable implements IUtilizable {

}

// Приватний клас стану Rx
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

// Абстрактний клас для Rx стану, який може бути використаний
abstract class UtilizableRxState<T extends StatefulWidget, V> extends UtilizableState<T> {

  late final _state = u(_RxState<V>());

  // Віджет, який автоматично оновлюється при зміні стану
  Widget obx(NotifierBuilder<V?> widget, {  Widget Function(String? error)? onError,  Widget? onLoading,  Widget? onEmpty}) {
    return _state.obx(widget, onError: onError, onLoading: onLoading, onEmpty: onEmpty);
  }

  V? get state => _state.state; // Поточний стан
  RxStatus get status => _state.status; // Статус стану

  change(V? newState, RxStatus status) {
    _state.setState(newState, status);
  }

  // Відкладений успіх
  delayedSuccess(V successState, Function() delayed) {
    CallUtils.timeout(() => change(successState, RxStatus.success()), 300); // Показуємо екран завантаження
    CallUtils.timeout(delayed, 2300); // Показуємо успішний екран після 2 секунд
  }

}

// Тип функції, який автоматично оброблюється під час ініціалізації
typedef U = T Function<T>(T);

// Віджет, який автоматично ініціалізується під час створення
class Autowire extends StatefulWidget {

  final Function(U u) onInit;
  const Autowire(this.onInit, {Key? key});

  @override
  State<StatefulWidget> createState() => _AutowireState();
}

// Приватний клас стану для Autowire
class _AutowireState extends UtilizableState<Autowire> {

  @override
  void initState() {
    super.initState();
    widget.onInit(u); // Ініціалізуємо функції автоматичного використання
  }

  @override
  Widget build(BuildContext context) => Empty.instance; // Пустий віджет

}
