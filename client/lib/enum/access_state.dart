

import 'package:client/service/translations_service.dart';

enum AccessState {

  granted,

  disabledUser,
  blockedUser,
  unknownUser,
  invalidCredentials,
  unexpectedError;

  String get t => 'accessState_$this'.T;

}