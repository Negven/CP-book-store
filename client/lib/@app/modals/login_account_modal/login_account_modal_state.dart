import 'package:flutter/material.dart';

import '@login_account_modal.dart';

// Оголошення глобального ключа для доступу до стану модального вікна
final loginAccountModal$Key = GlobalKey();

// Міксин ILoginAccountModal$State для доступу до стану модального вікна
mixin ILoginAccountModal$State {
  // Метод для отримання поточного стану модального вікна
  LoginAccountModalState get modalState => loginAccountModal$Key.currentState as LoginAccountModalState;
}
