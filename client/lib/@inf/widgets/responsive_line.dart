

import 'package:client/classes/sizes.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:flutter/material.dart';


class ResponsiveLineInfo {

  late final bool isColumn;
  late final double maxWidth;
  late final double? iconWidth;
  late final double? iconHeight;

  double get avatarSize => (iconWidth ?? iconHeight)! * 0.8;

  ResponsiveLineInfo() {
    isColumn = ScreenWidth.now < ScreenWidth.lg && ScreenAspect.isVertical;
    maxWidth = isColumn ? sizes.w80 : sizes.s9R;
    double? iconWidth = isColumn ? maxWidth * 0.8 : maxWidth;
    if (isColumn && iconWidth > sizes.h40) {
      iconHeight = sizes.h40;
      this.iconWidth = null;
    } else {
      iconHeight = null;
      this.iconWidth = iconWidth;
    }
  }
}

typedef ResponsiveLineBuilder = Widget Function(ResponsiveLineInfo);

class ResponsiveLine extends StatelessWidget {

  final ResponsiveLineBuilder content;
  final ResponsiveLineBuilder icon;
  final bool iconFirst;
  final bool iconCenter;

  const ResponsiveLine({super.key, required this.content, required this.icon, this.iconFirst = false, this.iconCenter = true});

  @override
  Widget build(BuildContext context) {

    final info = ResponsiveLineInfo();

    final content = Container(
      constraints: BoxConstraints(maxWidth: info.maxWidth),
      child: this.content.call(info),
    );

    Widget i = this.icon.call(info);
    if (iconCenter) {
      i = Center(child: i);
    }

    final icon = Container(
        constraints: BoxConstraints(maxWidth: info.maxWidth),
        child: i
    );

    if (info.isColumn) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [icon, content]
      );
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: iconFirst ? [icon, content]: [content, icon]
    );
  }


}

