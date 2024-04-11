import 'package:client/classes/unexpected_error.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/modal_scaffold.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:client/widgets/under_construction_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/universal/universal_button.dart';

// Результат підтвердження
enum ConfirmResult {
  confirm,
  cancel,
  other
}

// Тип для підтвердження результату
typedef ConfirmResultType = Future<ConfirmResult>;

// Сервіс для модальних вікон
class ModalsService extends GetxService {

  // Ключ для навігатора модальних вікон
  static final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ModalsNavigator');

  // Отримати стан навігатора
  NavigatorState get navigatorState => navigatorKey.currentState!;
  BuildContext get _context => navigatorState.context;

  @override
  void onInit() {
    super.onInit();

    // Прослуховування зміни шляху
    Services.navigation.currentPath.listen((_) {

      // Закрити будь-яке модальне вікно чи діалогове вікно при зміні шляху
      if (navigatorState.canPop()) {
        _closeAll();
      }

    });
  }

  // Закрити одне модальне вікно
  void closeOne() {
    if (navigatorState.canPop()) {
      navigatorState.pop();
    }
  }

  // Закрити з результатом
  void closeWith<T>(T? result) {
    if (navigatorState.canPop()) {
      navigatorState.pop<T>(result);
    }
  }

  // Закрити всі модальні вікна
  bool _closeAll() {

    var closed = false;

    while(navigatorState.canPop()) {
      closed = true;
      navigatorState.pop();
    }

    return closed;
  }

  // Подія відсутності натискання кнопки "Назад"
  Future<bool> onWillPop() async  {

    if (_closeAll()) {
      return false;
    }

    return true;
  }

  // Показати модальне вікно
  Future<T?> showModal<T>(PageBuilder modal) => showGeneralDialog<T>(
      context: _context,
      pageBuilder: (c, animation, secondaryAnimation) => ModalScaffold(modal),
      barrierDismissible: true,
      barrierLabel: 'x'
  );

  // Показати сповіщення
  ConfirmResultType showAlert(String content) async {
    return showConfirm(title: 'Alert'.T, content: content, ok: true);
  }

  // Показати підтвердження
  ConfirmResultType showConfirm({
    String? title, required String content,
    String? okText, bool ok = true,
    String? cancelText, bool? cancel,
    String? otherText, bool? other }) async {

    var result = await showDialog<ConfirmResult>(
        context: _context,
        builder: (BuildContext context) {

          var actions = <Widget>[];

          if (other == true || otherText != null) {
            actions.add(UniversalTextButton(
              text: otherText ?? 'Other'.T,
              onPressed: () => Navigator.pop(context, ConfirmResult.other),
            ));
          }

          if (cancel == true || cancelText != null) {
            actions.add(UniversalTextButton(
              text: cancelText ?? 'Cancel'.T,
              onPressed: () => Navigator.pop(context, ConfirmResult.cancel),
            ));
          }

          if (ok == true || okText != null) {
            actions.add(UniversalTextButton(
              text: okText ?? 'OK'.T,
              onPressed: () => Navigator.pop(context, ConfirmResult.confirm),
            ));
          }

          if (actions.isEmpty) throw UnexpectedError();

          return AlertDialog(
              title: Text(title ?? 'Confirm'.T),
              content: Text(content),
              actions: actions
          );
        }
    );

    return result ?? ConfirmResult.cancel;
  }

  // Показати панель сповіщень
  showSnackBar(String text) {
    ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(text))
    );
  }

  // Захистити від виконання, якщо не готово
  (String, VoidCallback) protectIfNotReady({required String title, required VoidCallback callback, required bool isReady}) {

    if (!isReady) {
      return (title, () => showModal(() => UnderConstructionModal(title: title)));
    }

    return (title, callback);
  }

  // Показати, якщо готово
  void showIfReady({required String title, required PageBuilder callback, required bool isReady}) {

    showModal(isReady ? callback : () => UnderConstructionModal(title: title));
  }
}
