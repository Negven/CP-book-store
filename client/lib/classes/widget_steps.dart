

import 'package:flutter/widgets.dart';



class WidgetStep<T> {

  final T step;
  T? previous;
  final Set<T> next;

  Widget? widget;
  WidgetStep(this.step) : next = {};

}

enum WidgetStepAction {

  go,
  skip,
  wait;

  bool get isGo => this == go;
}

class WidgetSteps<T> {

  final Map<T, WidgetStep<T>> _steps = {};

  late final WidgetStep<T> _root;

  T get root => _root.step;

  WidgetSteps(Map<T, dynamic> steps) {
    if (steps.length != 1) throw "Root must be single";
    var rootStep = steps.keys.first;
    _prepare(rootStep, steps);
    _root = _steps[rootStep]!;
  }

  WidgetStepAction canGoTo(T? step) {
    return step != null ? (widgetFor(step) != null ? WidgetStepAction.go : WidgetStepAction.skip) : WidgetStepAction.wait;
  }

  T? nextFor(T? step) {
    var next = _steps[step]!.next;
    return next.length == 1 ? next.first : null;
  }

  Widget? widgetFor(T step) =>
    _steps[step]!.widget;

  WidgetStep<T> _step(T step) {
    return _steps[step] ?? (_steps[step] = WidgetStep(step));
  }

  void _prepare(T step, dynamic config) {

    if (config is Widget) {
      _step(step).widget = config;
      return;
    }

    if (config is Map) {

      var previousStep = step;

      for (var entry in config.entries) {

        _prepare(entry.key, entry.value);

        if (previousStep != entry.key && entry.key != null) {
          _step(step).next.add(entry.key);
          _step(entry.key).previous = step;
        }
      }

      return;
    }

    if (config is List) {

      var previousStep = step;

      for (var i = 0; i < config.length; i++) {

        var child = config[i];
        if (child is Widget) {
          if (i != 0) throw "Invalid configuration format: Widget for List-step must have index 0";
          _prepare(step, child);
          continue;
        }

        if (child is Map<T, dynamic>) {
          if (child.length != 1) throw "Invalid configuration format: Children of list must be maps of size = 1";
          _prepare(previousStep, child);
          previousStep = child.keys.first;
          continue;
        }

        throw "Invalid configuration format: Unknown config type";
      }

      return;
    }

    throw "Invalid configuration format: Unknown config type";

  }

  bool isPreviousTo(T previous, T current) {

    if (!_steps.containsKey(previous) || !_steps.containsKey(current)) {
      throw "Unknown previous: $previous or current: $current steps";
    }

    T? currentPrevious = _steps[current]?.previous;

    while (currentPrevious != null) {
      if (currentPrevious == previous) {
        return true;
      }
      currentPrevious = _steps[currentPrevious]?.previous;
    }

    return false;
  }

}
