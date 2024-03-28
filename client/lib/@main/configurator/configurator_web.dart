

import 'package:client/utils/platform_specific_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'configurator_base.dart';

class ConfiguratorImpl extends IConfigurator {

  @override
  void configure() {

    logger.info("web.configure()");

    PlatformSpecificWeb();

    usePathUrlStrategy();
  }

}