
import 'package:flutter/services.dart';

enum KeyboardBiKey {

  enter(LogicalKeyboardKey.enter, PhysicalKeyboardKey.enter),
  escape(LogicalKeyboardKey.escape, PhysicalKeyboardKey.escape),
  arrowDown(LogicalKeyboardKey.arrowDown, PhysicalKeyboardKey.arrowDown),
  arrowUp(LogicalKeyboardKey.enter, PhysicalKeyboardKey.arrowUp),

  shiftLeft(LogicalKeyboardKey.shiftLeft, PhysicalKeyboardKey.shiftLeft),
  shiftRight(LogicalKeyboardKey.shiftRight, PhysicalKeyboardKey.shiftRight),
  metaLeft(LogicalKeyboardKey.metaLeft, PhysicalKeyboardKey.metaLeft),
  metaRight(LogicalKeyboardKey.metaRight, PhysicalKeyboardKey.metaRight),
  controlLeft(LogicalKeyboardKey.controlLeft, PhysicalKeyboardKey.controlLeft),
  controlRight(LogicalKeyboardKey.controlRight, PhysicalKeyboardKey.controlRight);

  final LogicalKeyboardKey _logical;
  final PhysicalKeyboardKey _physical;
  const KeyboardBiKey(LogicalKeyboardKey logical, PhysicalKeyboardKey physical) : _logical = logical, _physical = physical;

  bool isPressed(KeyEvent event) {
    return event.logicalKey == _logical || event.physicalKey == _physical;
  }

  static const metaKeys = [
    KeyboardBiKey.shiftLeft, KeyboardBiKey.shiftRight,
    KeyboardBiKey.metaLeft, KeyboardBiKey.metaRight,
    KeyboardBiKey.controlLeft, KeyboardBiKey.controlRight,
  ];

  static bool get isMetaPressed {

    for (var key in metaKeys) {
      if (RawKeyboard.instance.keysPressed.contains(key._logical) || RawKeyboard.instance.physicalKeysPressed.contains(key._physical)) {
        return true;
      }
    }

    return false;
  }
}