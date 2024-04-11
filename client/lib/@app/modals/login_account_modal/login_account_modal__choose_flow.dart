import 'package:client/@app/modals/login_account_modal/login_account_login.dart';
import 'package:client/@app/modals/login_account_modal/login_account_modal_state.dart';
import 'package:client/@app/modals/login_account_modal/login_account_registration.dart';
import 'package:client/enum/login_form_type.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../classes/sizes.dart';

// Імпорт класу UtilizableState для стану віджета
import '../../../classes/utilizable_state.dart';
import '../../../widgets/universal/universal_field.dart';
import '../../../widgets/universal/universal_radio_group.dart';

// Визначення класу LoginAccount$ChooseFlow, який є станом віджета для вибору потоку входу
class LoginAccount$ChooseFlow extends StatefulWidget  {
  const LoginAccount$ChooseFlow({super.key});

  @override
  State<StatefulWidget> createState() => LoginAccountChooseFlowState();
}

// Визначення класу LoginAccountChooseFlowState, який відповідає за вибір потоку входу
class LoginAccountChooseFlowState extends UtilizableState<LoginAccount$ChooseFlow> with ILoginAccountModal$State {
  late final UniversalController<UniversalRadioItem<LoginFormType>> formController;

  // Отримання типу форми входу
  LoginFormType get formType => formController.value!.value;

  @override
  void initState() {
    super.initState();
    formController = u(UniversalController<UniversalRadioItem<LoginFormType>>(LoginFormType.login.toRadioItem));
  }

  @override
  Widget build(BuildContext context) {
    // Повернення модального вікна з формою входу або реєстрації та вибором типу форми
    return Modal(
        title: "${"login".T} / ${"reg".T}",
        body: ModalBody(
            children: [
              Obx(() => formType == LoginFormType.login ? LoginAccountLogin() : LoginAccountRegistration()),
              sizes.sizedBoxV.xs,
              UniversalRadioGroup<LoginFormType>(
                items: LoginFormType.values.map((type) => type.toRadioItem).toList(),
                columns: 2,
                controller: formController,
              ),
              sizes.sizedBoxV.md
            ]
        ),
        footer: null
    );
  }
}
