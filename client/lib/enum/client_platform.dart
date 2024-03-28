

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum ClientPlatform {

  web,
  android,
  ios;

  static ClientPlatform get current => kIsWeb ? web : (GetPlatform.isAndroid ? android : (GetPlatform.isIOS ? ios : throw 'Unknown ClientPlatform!'));
}