

import 'package:client/classes/gradient_box_border.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';



class UniversalButton extends StatelessWidget {

  final SurfaceType? type;
  final ColorTheme? theme;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final FontIcon? icon;
  final IconPosition? iconPosition;
  final SizeVariant? iconSize;
  final String? text;
  final TextWeight? weight;
  final SizeVariant? elevation;
  final SizeVariant? padding;
  final SizeVariant? size;
  final SizeVariant? space;
  final SizeVariant? fontSize;
  final SurfaceShape? shape;
  final SizeVariant? radius;
  final void Function()? onPressed;
  final Widget? child;
  final LayoutOrientation? layoutOrientation;
  final AlignmentGeometry? alignment;
  final StrokeAlignment? strokeAlignment;
  final PaddingType? paddingType;
  final Color? overlayColor;
  final SizeVariant? border;
  final Widget Function(Widget icon)? iconWrapper;
  final Gradient? underBorder;
  final UniversalTemplate? template;

  const UniversalButton({ super.key, this.type, this.theme,  this.iconColor, this.textColor, this.backgroundColor, this.borderColor, this.icon, this.iconPosition, this.iconSize, this.text, this.onPressed, this.weight, this.elevation, this.padding, this.shape, this.template, this.child, this.size, this.fontSize, this.layoutOrientation, this.alignment, this.paddingType, this.overlayColor, this.space, this.border, this.radius, this.iconWrapper, this.underBorder, this.strokeAlignment });

  @override
  Widget build(BuildContext context) {

    final s = UniversalButtonStyle.from(type: type, theme: theme, textColor: textColor, iconColor: iconColor, backgroundColor: backgroundColor, borderColor: borderColor, size: size, weight: weight, elevation: elevation, padding: padding, shape: shape, template: template, fontSize: fontSize, layoutOrientation: layoutOrientation, iconVariant: iconPosition, textAlignment: alignment, paddingType: paddingType, overlayColor: overlayColor, space: space, border: border, radius: radius, iconSize: iconSize, underBorder: underBorder, strokeAlignment: strokeAlignment);

    Widget? i;
    if (icon != null) {
      i = icon!.fontIcon(size: s.iconSize, shape: s.shape, color: s.iconColor);
      if (iconWrapper != null) {
        i = iconWrapper!(i);
      }
    }

    Widget? c = child;
    if (text != null) {

      if (c != null) throw "Content must be null to use text";

      final height = sizes.lineHeight.get(s.textSize);
      c = UniversalFixedText(text: text!, lineHeight: height, alignment: s.textAlignment);
    }

    if (i != null && c != null) {

      if (s.layoutOrientation == LayoutOrientation.vertical) {

        final box = sizes.sizedBoxV.get(s.spaceSize);
        final last = sizes.sizedBoxV.get(s.spaceSize.smaller);
        c = Column(children: [ box, i, box, c, last ]);

      } else {

        // Horizontal
        double padding = sizes.paddingI.get(s.spaceSize);

        final startPadding = padding;
        final endPadding = padding / 2; // end padding to better visual balance

        bool isPrefix = s.iconPosition == IconPosition.prefix;
        final p = isPrefix ? EdgeInsets.only(left: startPadding, right: endPadding) : EdgeInsets.only(right: startPadding, left: endPadding);

        MainAxisAlignment? mainAxisAlignment;
        if (s.textAlignment == Alignment.center) {
          mainAxisAlignment = MainAxisAlignment.center;
        } else if (s.textAlignment == Alignment.centerLeft) {
          mainAxisAlignment = MainAxisAlignment.start;
        }

        c = Row(
          mainAxisAlignment: mainAxisAlignment!,
            children: [
          if (isPrefix) i,
          Padding(
              padding: p,
              child: c),
          if (!isPrefix) i
        ]);

      }

    } else if (i != null) {
      c = i;
    }

    Widget buttonChild = Padding(
      padding: sizes.insetsBy(s.paddingType, s.paddingSize),
      child: c,
    );

    if (s.underBorder != null) {
      buttonChild = Container(
        decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: s.underBorder!,
              width: sizes.border.get(s.borderSize),
            ),
            borderRadius: sizes.borderRadiusCircular.get(s.radiusSize)
        ),
        child: buttonChild
      );
    }

    // NB! For strokeAlignment clip must be = none
    return OutlinedButton(
        onPressed: onPressed,
        style: context.styles.buildFrom(s),
        child: buttonChild
    );
  }

}

class UniversalTextButton extends UniversalButton {

  const UniversalTextButton({super.key, super.theme, super.iconColor, super.textColor, super.backgroundColor, super.borderColor, super.icon, super.iconSize, super.iconPosition, super.iconWrapper, super.text, super.onPressed, super.weight, super.elevation, super.padding, super.shape, super.template, super.child, super.size, super.fontSize, super.layoutOrientation, super.alignment, super.paddingType, super.overlayColor, super.space, super.border, super.radius, super.strokeAlignment, super.underBorder}): super(type: SurfaceType.text);

}


class UniversalOutlinedButton extends UniversalButton {

  const UniversalOutlinedButton({super.key, super.theme, super.iconColor, super.textColor, super.backgroundColor, super.borderColor, super.icon, super.iconSize, super.iconPosition, super.iconWrapper, super.text, super.onPressed, super.weight, super.elevation, super.padding, super.shape, super.template, super.child, super.size, super.fontSize, super.layoutOrientation, super.alignment, super.paddingType, super.overlayColor, super.space, super.border, super.radius, super.strokeAlignment, super.underBorder}): super(type: SurfaceType.outlined);

}

class UniversalFilledButton extends UniversalButton {

  const UniversalFilledButton({super.key, super.theme, super.iconColor, super.textColor, super.backgroundColor, super.borderColor, super.icon, super.iconSize, super.iconPosition, super.iconWrapper, super.text, super.onPressed, super.weight, super.elevation, super.padding, super.shape, super.template, super.child, super.size, super.fontSize, super.layoutOrientation, super.alignment, super.paddingType, super.overlayColor, super.space, super.border, super.radius, super.strokeAlignment, super.underBorder}): super(type: SurfaceType.filled);

}

