

import 'dart:typed_data';

import 'package:client/utils/encryption_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

abstract class FileUtils {

  static void downloadTextAsUtf8File(String fileName, String content) {
    FileSaver.instance.saveFile(name: fileName,
        bytes: Uint8List.fromList(EncryptionUtils.utf8Encode(content)),
        ext: 'txt',
        mimeType: MimeType.text
    );
  }

  static Future<String?> pickAndReadUtf8TextFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result == null) {
      return null;
    }

    Uint8List fileBytes = result.files.single.bytes!;
    return EncryptionUtils.utf8Decode(fileBytes);
  }

}