

import 'package:client/utils/platform_specific_mobile.dart';

import 'configurator_base.dart';

class ConfiguratorImpl extends IConfigurator {

  @override
  void configure() {

    logger.info("mobile.configure()");

    PlatformSpecificMobile();
  }

}