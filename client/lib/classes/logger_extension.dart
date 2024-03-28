

import 'package:logging/logging.dart';

extension LoggerExtension on Logger {

  infoOnChange<T>(String prefix, T? previous, T? now) {
    if (previous != now) {
      info("$prefix = $now");
    }
  }

}