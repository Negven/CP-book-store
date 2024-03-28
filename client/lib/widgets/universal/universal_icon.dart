
import 'package:client/classes/sizes.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:flutter/material.dart';


// Simplified version of Icon to make possible adjust box size
// Opacity and color are inherited based on IconTheme
class UniversalIcon extends StatelessWidget {

  final String icon;
  final TextStyle style;

  final double lineHeight;

  final Color? color;
  final double? opacity;

  const UniversalIcon({
        super.key,
        required this.icon,
        required this.style,
        required this.lineHeight,
        this.color,
        this.opacity
      });

  @override
  Widget build(BuildContext context) {

    final IconThemeData iconTheme = IconTheme.of(context); // Button will change IconThemeData

    Color color = this.color ?? iconTheme.color!;

    final opacity = this.opacity ?? iconTheme.opacity;
    if (opacity != null) {
      color = color.withOpacity(opacity);
    }

    Widget iconWidget = RichText(
      overflow: TextOverflow.visible,
      text: TextSpan(
        text: icon,
        style: style.copyWith(color: color),
      ),
    );


    return SizedBox(
        width: lineHeight,
        height: lineHeight,
        child: Center(
          child: iconWidget
        )
    );
  }

}


class UniversalFixedText extends StatelessWidget {

  final String text;
  final double lineHeight;
  final AlignmentGeometry? alignment;

  const UniversalFixedText({super.key, required this.text, required this.lineHeight, this.alignment});

  @override
  Widget build(BuildContext context) {

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    Widget richText = RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        text: text,
        style: defaultTextStyle.style
      ),
    );


    return SizedBox(
        width: null,
        height: lineHeight,
        child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: richText
        )
    );
  }

}


extension UniversalIconExtension on FontIcon {

  UniversalIcon fontIcon({ SizeVariant size = SizeVariant.base, Color? color, SurfaceShape? shape, double? lineHeight }) {

    final fontSize = sizes.icon.get(size);

    // Making icon a bit smaller to make circle icons have more "air"
    final k = shape == SurfaceShape.circle ? 0.94 : 1.0;

    final style = TextStyle(
        inherit: false,
        fontSize: fontSize * k,
        fontFamily: FontUtils.icons,
        height: lineHeight
    );

    return UniversalIcon(icon: String.fromCharCode(codePoint), style: style, lineHeight: sizes.lineHeight.get(size), color: color);
  }

}