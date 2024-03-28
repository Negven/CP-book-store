

import 'package:flutter/cupertino.dart';



extension UniversalOpacityExtensionN on Widget? {

  Widget? withOpacity(double? opacity) =>
      this?.withOpacity(opacity);

}

extension UniversalOpacityExtensionR on Widget {

  Widget withOpacity(double? opacity) {
    if (opacity == null) return this;
    return Opacity(opacity: opacity, child: this);
  }

}