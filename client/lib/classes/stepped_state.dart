

import 'package:client/classes/lazy.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/classes/widget_steps.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// import '../@app/modals/account_create/create_account_modal_state.dart';
// import '../@app/modals/institution_integration_add/@add_institution_integration_modal.dart';


mixin SteppedStep {
  WidgetStepAction get canGoBack => WidgetStepAction.go;
  WidgetStepAction get canGoNext => WidgetStepAction.go;
}
final multiStateModalKey = GlobalKey();

mixin IMultiModal$State {

  MultiState get multiState => multiStateModalKey.currentState as MultiState;
  // InstitutionIntegrationModal$Add$State get institutionState => multiState.state();
  // CreateAccountModalState get createAccountModalState => multiState.state();

}


abstract class MultiState<SP, W extends StatefulWidget> extends UtilizableState<W> with SteppedState<SP> {

  final Map<dynamic, dynamic> _states = {};

  ST initModalState<ST>();

  ST state<ST>() {
    if(_states[ST] == null) {
      _states[ST] = initModalState<ST>();
    }
    return _states[ST];
  }


}

mixin SteppedState<T> {

  Map<T, dynamic> get stepsTree;

  late final _steps = Lazy<WidgetSteps<T>>(() => WidgetSteps<T>(stepsTree));
  WidgetSteps<T> get steps => _steps.value;

  final RxList<T> _history = RxList();

  T get current => _history.last;

  set current(T step) {

    var previous = _history.lastOrNull;
    if (previous == step) {
      return;
    }

    var action = canGoTo(step);
    if (action == WidgetStepAction.go) {

      final i = _history.lastIndexOf(step);
      if (i >= 0) {
        _history.removeRange(i + 1, _history.length); // going back
      } else if (_history.lastOrNull != step) {
        _history.add(step);
      }

    } else if (action == WidgetStepAction.skip) {
      if (isPrevious(step)) {
        goBack(step);
      } else {
        goNext(true, step);
      }
    }
  }

  bool isPrevious(T step) => steps.isPreviousTo(step, current);

  T firstStep() => steps.root;

  bool get isFirstStep => _history.isNotEmpty && _history.first == current;

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

  WidgetStepAction canGoTo(T? next) => steps.canGoTo(next);

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
