


import 'dart:ui';

import 'package:client/classes/sizes.dart';
import 'package:client/utils/platform_specific_utils.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareUtils {

  static bool get canShareTextAsAppDocumentFile => PlatformSpecific.utils.canShareTextAsAppDocumentFile;
  Future<String> shareTextAsAppDocumentFile(String fileName, String content) => PlatformSpecific.utils.shareTextAsAppDocumentFile(fileName, content);

  static Future<void> share(String text, String subject) =>
    Share.share(text, subject: subject, sharePositionOrigin: Rect.fromLTWH(0, 0, sizes.w100, sizes.h100));

}