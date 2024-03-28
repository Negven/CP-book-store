

import 'package:flutter/material.dart';

import '@login_account_modal.dart';

final loginAccountModal$Key = GlobalKey();

mixin ILoginAccountModal$State {

  LoginAccountModalState get modalState => loginAccountModal$Key.currentState as LoginAccountModalState;
}