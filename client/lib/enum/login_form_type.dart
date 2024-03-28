
import 'package:client/service/translations_service.dart';

import '../widgets/universal/universal_radio_group.dart';

enum LoginFormType {
  login,
  reg;

  UniversalRadioItem<LoginFormType> get toRadioItem => UniversalRadioItem(this, null, this.name.T);

}