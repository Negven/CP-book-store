import 'package:client/classes/keyboard_key.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/global_event.dart';
import 'package:client/service/_services.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


enum UniversalEvent {
  submit,
  arrowUp,
  arrowDown,
  uploadMore,
  closeModal,
  closeWith
}

class UniversalFieldEvent {

  final int stateId;
  final UniversalEvent event;
  final Object? payload;

  UniversalFieldEvent(this.stateId, this.event, this.payload);

}

// NB! Needed to track additional values
// NB! Should only be non-disposable fields

extension UniversalFieldContextExtension on UtilizableState {

  void listenSimple(GlobalEvent event, Function(GlobalEvent) listener) {
    u(Services.events.listen(event, listener));
  }

  void listenUniversal(Function(UniversalEvent, Object? payload) listener, [int? stateId]) {
    u(Services.events.listen(GlobalEvent.universalField, (UniversalFieldEvent event) {
      final id = stateId ?? UniversalFieldContext.stateId(context);
      if (id == event.stateId) listener.call(event.event, event.payload);
    }));
  }

}

class UniversalFieldContext extends InheritedWidget {

  final int _stateId;
  final SubmitType submitType;
  final UniversalItem? _selectedItem;

  const UniversalFieldContext({
    required int stateId,
    this.submitType = SubmitType.enter,
    UniversalItem? selectedItem,
    super.key,
    required super.child
  }) : _selectedItem = selectedItem, _stateId = stateId;

  @override
  bool updateShouldNotify(covariant UniversalFieldContext oldWidget) {
    return oldWidget._stateId != _stateId || oldWidget.submitType != submitType || oldWidget._selectedItem != _selectedItem;
  }

  static UniversalFieldContext _of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UniversalFieldContext>()!;
  }

  void _trigger(UniversalEvent universalEvent, [Object? payload]) {
    Services.events.trigger(GlobalEvent.universalField, UniversalFieldEvent(_stateId, universalEvent, payload));
  }

  static trigger(BuildContext buildContext, UniversalEvent universalEvent) =>
    _of(buildContext)._trigger(universalEvent);

  static closeWith(BuildContext buildContext, Object? payload) =>
    _of(buildContext)._trigger(UniversalEvent.closeWith, payload);

  static int stateId(BuildContext buildContext) =>
    _of(buildContext)._stateId;

  static UniversalItem? selectedItem(BuildContext buildContext) =>
    _of(buildContext)._selectedItem;

  bool _submit() {
    switch (submitType) {
      case SubmitType.none:
        return false;
      case SubmitType.enter:
        _trigger(UniversalEvent.submit);
        return true;
      case SubmitType.metaEnter:
        if (!KeyboardBiKey.isMetaPressed) return false;
        _trigger(UniversalEvent.submit);
        return true;
    }
  }

  static bool submit(BuildContext buildContext)
    => _of(buildContext)._submit();

  bool _onKeyDown(KeyEvent event) {

    if (KeyboardBiKey.enter.isPressed(event)) {
      return _submit();
    }

    if (KeyboardBiKey.escape.isPressed(event)) {
      _trigger(UniversalEvent.closeModal);
      return true;
    }

    if (KeyboardBiKey.arrowDown.isPressed(event)) {
      _trigger(UniversalEvent.arrowDown);
      return true;
    }

    if (KeyboardBiKey.arrowUp.isPressed(event)) {
      _trigger(UniversalEvent.arrowUp);
      return true;
    }

    return false;
  }


  static KeyEventResult onKeyEvent (BuildContext buildContext, KeyEvent event) =>
    ((event is KeyDownEvent || event is KeyRepeatEvent) && _of(buildContext)._onKeyDown(event)) ? KeyEventResult.handled : KeyEventResult.ignored;




}

