

import 'package:client/service/translations_service.dart';

enum AccessState {

  granted;

  String get t => 'accessState_$this'.T;

}