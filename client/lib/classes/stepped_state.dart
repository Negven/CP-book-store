import 'package:client/classes/lazy.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/classes/widget_steps.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// Міксін для крокового інтерфейсу
mixin SteppedStep {
  WidgetStepAction get canGoBack => WidgetStepAction.go; // Дозволений крок назад
  WidgetStepAction get canGoNext => WidgetStepAction.go; // Дозволений крок вперед
}

// Міксін для крокового стану
mixin SteppedState<T> {

  // Дерево кроків
  Map<T, dynamic> get stepsTree;

  late final _steps = Lazy<WidgetSteps<T>>(() => WidgetSteps<T>(stepsTree)); // Ліниве створення екземпляру класу кроків
  WidgetSteps<T> get steps => _steps.value; // Доступ до кроків

  final RxList<T> _history = RxList(); // Історія кроків

  T get current => _history.last; // Поточний крок

  set current(T step) {

    var previous = _history.lastOrNull;
    if (previous == step) { // Якщо поточний крок вже встановлено
      return;
    }

    var action = canGoTo(step);
    if (action == WidgetStepAction.go) { // Якщо дозволений перехід на крок

      final i = _history.lastIndexOf(step);
      if (i >= 0) {
        _history.removeRange(i + 1, _history.length); // Перехід назад
      } else if (_history.lastOrNull != step) {
        _history.add(step); // Додати новий крок до історії
      }

    } else if (action == WidgetStepAction.skip) {
      if (isPrevious(step)) {
        goBack(step);
      } else {
        goNext(true, step);
      }
    }
  }

  bool isPrevious(T step) => steps.isPreviousTo(step, current); // Перевірка, чи є крок попереднім до поточного

  T firstStep() => steps.root; // Перший крок

  bool get isFirstStep => _history.isNotEmpty && _history.first == current; // Чи є поточний крок першим

  WidgetStepAction canGoBack(T? next) {

    if (next is SteppedStep) {
      var backAction = next.canGoBack;
      if (!backAction.isGo) {
        return backAction;
      }
    }

    return canGoTo(next);
  }

  WidgetStepAction canGoNext(T? next) {

    if (next is SteppedStep) {
      var nextAction = next.canGoNext;
      if (!nextAction.isGo) {
        return nextAction;
      }
    }

    return canGoTo(next);
  }

  WidgetStepAction canGoTo(T? next) => steps.canGoTo(next); // Перевірка можливості переходу на крок

  void goBack([T? from]) {

    final fromIndex = _history.indexOf(from ?? current);

    for (var i = fromIndex - 1; i >= 0; i--) {

      final to = _history[i];
      final action = canGoBack(to);

      if (action == WidgetStepAction.skip) {
        continue;
      } else if (action.isGo) {
        current = to;
      }

      return;
    }

  }

  void goNext([bool isValid = true, T? fromStep]) {
    if (isValid) {
      var from = fromStep ?? current;
      T? to = steps.nextFor(from);
      final action = canGoNext(to);
      if (action == WidgetStepAction.skip) {
        goNext(isValid, to);
      } else if (action.isGo) {
        current = to as T;
      }
    }
  }

  Widget steppedWidget() {

    if (_history.lastOrNull == null) {
      current = firstStep();
    }

    return Obx(() => steps.widgetFor(current)!);
  }

}
