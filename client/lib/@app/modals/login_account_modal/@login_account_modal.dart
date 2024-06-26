import 'package:client/@app/modals/login_account_modal/login_account_modal_state.dart';
import 'package:client/classes/stepped_state.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/env/env.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/string_utils.dart';
import 'package:flutter/material.dart';

import '@login_account_modal_step.dart';

class LoginAccountModal extends StatefulWidget {
  final String title;

  LoginAccountModal(this.title) : super(key: loginAccountModal$Key);

  @override
  State<StatefulWidget> createState() => LoginAccountModalState();

  // Статичний метод для обробки входу в систему
  static (String, ColorTheme, VoidCallback) signIn() {
    // Перевірка, чи користувач вже увійшов в систему
    if (Services.auth.isSignedIn) {
      final title = 'addWalletModal_logIn'.T;
      return (title, ColorTheme.success, () => Services.navigation.goToInitial());
    }

    final title = 'addWalletModal_signIn'.T;
    return (title, ColorTheme.primary, () => Services.modals.showIfReady(title: title, callback: () => LoginAccountModal(title), isReady: !iEnv.isProd));
  }

  // Статичний метод для створення колбеку для відображання модального вікна
  static (String, VoidCallback) addOne() {
    final title =  "${"login".T} / ${"reg".T}";
    return (title, () => Services.modals.showIfReady(title: title, callback: () => LoginAccountModal(title), isReady: !iEnv.isProd));
  }
}

class LoginAccountModalState extends UtilizableState<LoginAccountModal> with SteppedState<LoginAccountModalStep> {
  // Перевизначений метод для визначення дерева кроків
  @override
  Map<LoginAccountModalStep, dynamic> get stepsTree => LoginAccountModalStep.steps;


  // Перевизначений метод build для повернення віджета з кроками для відображення модального вікна
  @override
  Widget build(BuildContext context) => steppedWidget();
}
