

import 'dart:io';

import 'package:client/utils/platform_specific_utils.dart';
import 'package:path_provider/path_provider.dart';

class PlatformSpecificMobile extends PlatformSpecific {

  @override
  bool get canShareTextAsAppDocumentFile => true;

  @override
  Future<String> shareTextAsAppDocumentFile(String fileName, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    file.writeAsStringSync(content);
    return file.path;
  }

}