import 'package:client/env/env.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

// Сервіс для логування
class LoggingService extends GetxService {

  // Налаштування перед ініціалізацією
  static beforeInit() {
    Logger.root.level = Level.INFO; // Рівень логування
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) { // Якщо у режимі налагодження
        print('${record.level.name[0]} ${record.message} @ ${record.loggerName}'); // Вивести лог
      }
    });
  }
}
