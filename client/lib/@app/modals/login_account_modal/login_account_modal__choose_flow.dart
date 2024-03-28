

import 'package:client/@app/modals/login_account_modal/login_account_login.dart';
import 'package:client/@app/modals/login_account_modal/login_account_modal_state.dart';
import 'package:client/@app/modals/login_account_modal/login_account_registration.dart';
import 'package:client/enum/login_form_type.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../classes/sizes.dart';
import '../../../classes/utilizable_state.dart';
import '../../../widgets/universal/universal_field.dart';
import '../../../widgets/universal/universal_radio_group.dart';

class LoginAccount$ChooseFlow extends StatefulWidget  {

  const LoginAccount$ChooseFlow({super.key});

  @override
  State<StatefulWidget> createState() => LoginAccountChooseFlowState();

}


class LoginAccountChooseFlowState extends UtilizableState<LoginAccount$ChooseFlow> with ILoginAccountModal$State {

  late final UniversalController<UniversalRadioItem<LoginFormType>> formController;

  LoginFormType get formType => formController.value!.value;

  @override
  void initState() {
    super.initState();
    formController = u(UniversalController<UniversalRadioItem<LoginFormType>>(LoginFormType.login.toRadioItem));
  }

  void onNext() {

  }

  @override
  Widget build(BuildContext context) {
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
