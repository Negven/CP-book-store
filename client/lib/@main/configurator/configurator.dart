

import 'configurator_stub.dart'
  if (dart.library.io) 'configurator_mobile.dart'
  if (dart.library.html) 'configurator_web.dart';

class Configurator extends ConfiguratorImpl {

  static run() {
    Configurator().configure();
  }

}