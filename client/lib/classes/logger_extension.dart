import 'package:logging/logging.dart';

// Розширення класу `Logger`
extension LoggerExtension on Logger {

  // Метод `infoOnChange` для логування змін значення
  infoOnChange<T>(String prefix, T? previous, T? now) {
    // Якщо значення змінилося, записуємо його в журнал
    if (previous != now) {
      info("$prefix = $now");
    }
  }

}
