
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class ClipboardUtils {

  static Future<void> copyText(String text, { bool silent = false }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Services.modals.showSnackBar('clipboard_textCopied'.T);
    } catch (e) {
      debugPrint(e.toString());
      Services.modals.showSnackBar('clipboard_textCopyFailed'.T);
    }
  }

  static Future<String?> pasteText() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    return cdata?.text;
  }
}