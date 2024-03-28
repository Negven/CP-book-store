

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


abstract class NetworkUtils {

  static String prepareUrl(String url) {

    if (kDebugMode) {
      if (GetPlatform.isAndroid) {
        url = url.replaceFirst("localhost", "10.0.2.2"); // NB! On Android localhost == device
      }
    }

    return url;

  }

  static Uri parseUrl(String url) {
    return Uri.parse(prepareUrl(url));
  }

  static Future<bool> openUrl(String url) {
    return launchUrl(parseUrl(url), mode: LaunchMode.externalApplication); // NB! LaunchMode.externalApplication - allows to use window.close()
  }
}