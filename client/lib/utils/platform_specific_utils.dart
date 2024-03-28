

import 'dart:async';

abstract class PlatformSpecific {

  // region Initialization

  PlatformSpecific() {
    PlatformSpecific.utils = this;
  }

  static PlatformSpecific? _utils;

  static PlatformSpecific get utils => _utils!;

  static set utils(PlatformSpecific value) {

    if (_utils != null) {
      throw 'WTF?';
    }

    _utils = value;
  }

  // endregion

  // region Interface

  bool get canShareTextAsAppDocumentFile => false;

  Future<String> shareTextAsAppDocumentFile(String fileName, String content) async {
    throw 'NIE';
  }

  // endregion

}

