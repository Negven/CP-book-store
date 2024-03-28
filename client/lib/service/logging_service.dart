import 'package:client/env/env.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

// Service because in future we will collect information about bugs on client devices
class LoggingService extends GetxService {

  static beforeInit() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name[0]} ${record.message} @ ${record.loggerName}');
      }
    });
  }

  @override
  void onInit() {
    super.onInit();

    if (iEnv.isProd) {
      Logger.root.level = Level.WARNING;
      Logger.root.onRecord.listen((record) {
        if (kDebugMode) {
          print('${record.level.name[0]} ${record.message} @ ${record.loggerName}');
        } else {
          // TODO send logs
        }
      });
    }

  }
}
