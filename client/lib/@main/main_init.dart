import 'package:client/env/env.dart';
import 'package:client/service/auth_service.dart';
import 'package:client/service/events_service.dart';
import 'package:client/service/logging_service.dart';
import 'package:client/service/modals_service.dart';
import 'package:client/service/navigation_service.dart';
import 'package:client/service/public_api_service.dart';
import 'package:client/service/storage_service.dart';
import 'package:client/service/themes_service.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/master_colors.dart';
import 'package:client/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

// Клас MainInit для ініціалізації додатку
class MainInit {
  // Статичний метод beforeAppStart для ініціалізації додатку перед запуском
  static beforeAppStart() async {
    iEnv.validate();

    // Ініціалізація режиму розробника
    LoggingService.beforeInit();

    // Перед використанням Get
    final Logger getLogger = Logger("GetX");

    Get.config(
      enableLog: true,
      logWriterCallback: (text, {bool isError = false}) {
        if (isError) {
          getLogger.severe(text);
        } else {
          getLogger.info(text);
        }
      },
      // NB! Не встановлюючи переходи, оскільки навігація буде використовуватися з go_router.
    );

    if (iEnv.isDev) {
      MasterColors.printSvgColors();
    }

    // Налаштування

    // Найважливіші сервіси
    WidgetsFlutterBinding.ensureInitialized();
    FontUtils.init();
    Get.put(LoggingService(), permanent: true);
    Get.put(EventsService(), permanent: true);
    Get.put(await initStorageService(), permanent: true);

    // Інші постійні сервіси
    Get.put(NavigationService(), permanent: true);
    Get.put(TranslationsService(), permanent: true);
    Get.put(ThemesService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(ModalsService(), permanent: true);
    Get.lazyPut(() => PublicApiService());
  }
}
