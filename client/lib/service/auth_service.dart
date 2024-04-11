import 'dart:async';

import 'package:client/dto/access_state_dto.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '_services.dart';

// Сервіс автентифікації
class AuthService extends GetxService {

  final LocalStorage storage = LocalStorage('book_store.json'); // Локальне сховище

  // Увійти в систему
  void signIn(AccessStateDto value) {
    storage.setItem("token", value.token); // Зберегти токен
    storage.setItem('userId', value.userId); // Зберегти ID користувача
    triggerChange(); // Запустити подію зміни
    Services.modals.closeOne(); // Закрити модальне вікно
  }

  // Перевірка, чи користувач увійшов в систему
  bool get isSignedIn => storage.getItem("token") != null;

  // Отримати токен
  String get token => storage.getItem("token");

  // Вийти з системи
  void logOut () {
    storage.deleteItem("token"); // Видалити токен
    triggerChange(); // Запустити подію зміни
  }

  // Зберегти дані автентифікації
  storeCredentials() {
    triggerChange(); // Запустити подію зміни
  }

  final event = 0.obs; // Подія зміни

  // Запустити подію зміни
  void triggerChange() {
    event.value++;
  }

  // Слухати подію зміни
  StreamSubscription<int> listen(Function() fn, { bool instant = false }) {
    try {
      return event.listen((_) { fn.call(); }); // Прослуховувати подію
    } finally {
      if (instant) fn.call(); // Викликати функцію, якщо необхідно
    }
  }
}
