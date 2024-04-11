import 'package:client/classes/keyboard_key.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/global_event.dart';
import 'package:client/service/_services.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Перерахування для подій, пов'язаних з полем UniversalField.
enum UniversalEvent {
  submit, // Відправити форму
  arrowUp, // Натискання клавіші "Вгору"
  arrowDown, // Натискання клавіші "Вниз"
  uploadMore, // Завантажити більше
  closeModal, // Закрити модальне вікно
  closeWith // Закрити зі значенням
}

// Клас, який представляє подію поля UniversalField.
class UniversalFieldEvent {
  final int stateId; // Ідентифікатор стану
  final UniversalEvent event; // Тип події
  final Object? payload; // Дані

  UniversalFieldEvent(this.stateId, this.event, this.payload);
}

// Розширення для контексту поля UniversalField.
extension UniversalFieldContextExtension on UtilizableState {
  // Слухати глобальні події та викликати функцію при їх спрацюванні.
  void listenSimple(GlobalEvent event, Function(GlobalEvent) listener) {
    u(Services.events.listen(event, listener));
  }

  // Слухати події UniversalField та викликати функцію при їх спрацюванні.
  void listenUniversal(Function(UniversalEvent, Object? payload) listener, [int? stateId]) {
    u(Services.events.listen(GlobalEvent.universalField, (UniversalFieldEvent event) {
      final id = stateId ?? UniversalFieldContext.stateId(context);
      if (id == event.stateId) listener.call(event.event, event.payload);
    }));
  }
}

// Клас, який представляє контекст поля UniversalField.
class UniversalFieldContext extends InheritedWidget {
  final int _stateId; // Ідентифікатор стану
  final SubmitType submitType; // Тип натискання кнопки "Enter"
  final UniversalItem? _selectedItem; // Обраний елемент

  const UniversalFieldContext({
    required int stateId,
    this.submitType = SubmitType.enter,
    UniversalItem? selectedItem,
    Key? key,
    required Widget child,
  }) : _selectedItem = selectedItem,
        _stateId = stateId,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant UniversalFieldContext oldWidget) {
    return oldWidget._stateId != _stateId || oldWidget.submitType != submitType || oldWidget._selectedItem != _selectedItem;
  }

  // Отримати екземпляр UniversalFieldContext з контексту.
  static UniversalFieldContext _of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UniversalFieldContext>()!;
  }

  // Запустити подію UniversalEvent.
  void _trigger(UniversalEvent universalEvent, [Object? payload]) {
    Services.events.trigger(GlobalEvent.universalField, UniversalFieldEvent(_stateId, universalEvent, payload));
  }

  // Викликати подію UniversalEvent з контексту поля UniversalField.
  static trigger(BuildContext buildContext, UniversalEvent universalEvent) =>
      _of(buildContext)._trigger(universalEvent);

  // Закрити зі значенням.
  static closeWith(BuildContext buildContext, Object? payload) =>
      _of(buildContext)._trigger(UniversalEvent.closeWith, payload);

  // Отримати ідентифікатор стану з контексту поля UniversalField.
  static int stateId(BuildContext buildContext) =>
      _of(buildContext)._stateId;

  // Отримати обраний елемент з контексту поля UniversalField.
  static UniversalItem? selectedItem(BuildContext buildContext) =>
      _of(buildContext)._selectedItem;

  // Викликати відправку форми з контексту поля UniversalField.
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

  // Викликати обробку натискання клавіші з контексту поля UniversalField.
  static bool submit(BuildContext buildContext)
  => _of(buildContext)._submit();

  // Обробити натискання клавіші.
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

  // Обробник події клавіатури.
  static KeyEventResult onKeyEvent(BuildContext buildContext, KeyEvent event) =>
      ((event is KeyDownEvent || event is KeyRepeatEvent) && _of(buildContext)._onKeyDown(event)) ? KeyEventResult.handled : KeyEventResult.ignored;
}
