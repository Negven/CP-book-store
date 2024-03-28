

import 'package:logging/logging.dart';

abstract class IConfigurator {

  final Logger logger = Logger((IConfigurator).toString());

  void configure() {
    throw "stub.configure()";
  }
}

