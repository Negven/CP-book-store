

import 'dart:math';
import 'dart:ui';

import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/universal/universal_ink_well.dart';
import 'package:client/widgets/universal/universal_opacity.dart';
import 'package:client/widgets/universal/universal_surface_style.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:flutter/material.dart';


class UniversalSurface extends StatelessWidget {

  final SurfaceType? type;
  final ColorTheme? theme;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final SizeVariant? elevation;
  final SurfaceShape? shape;
  final SizeVariant? size;
  final SizeVariant? radius;
  final SizeVariant? padding;
  final PaddingType? paddingType;
  final SizeVariant? border;
  final AlignmentGeometry? alignment;
  final UniversalTemplate? template;

  final Widget? child;

  const UniversalSurface({ super.key, this.type, this.theme, this.textColor, this.borderColor, this.backgroundColor, this.elevation, this.padding, this.shape, this.template, this.child, this.size, this.paddingType, this.border, this.radius, this.alignment });

  @override
  Widget build(BuildContext context) {

    final s = UniversalSurfaceStyle.from(type: type, size: size, elevation: elevation, padding: padding, theme: theme, shape: shape, template: template, backgroundColor: backgroundColor, paddingType: paddingType, border: border, radius: radius, textAlignment: alignment, textColor: textColor);

    const isActive = true;

    final elevationColor = context.styles.surfaceElevationColor(s.type, s.elevationSize, isActive);
    final background = context.styles.surfaceBackgroundColor(s.type, s.backgroundColor, elevationColor, isActive, context.color4background);

    final container = Container(
        color: background,
        padding: sizes.insetsBy(s.paddingType, s.paddingSize),
        alignment: s.textAlignment,
      child: child
    );

    final shapeBase = sizes.shapeBy(s.shape, s.radiusSize);
    final shapeSide = shapeBase.copyWith(
      side: context.styles.surfaceBorderSide(s.borderSize, s.borderColor, s.strokeAlignment, isActive, false)
    );

    return Material(
        shape: shapeSide,
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: s.elevationSize.isNone ? 0.0 : sizes.elevation.get(s.elevationSize),
        shadowColor: elevationColor,
        clipBehavior: Clip.antiAlias,
        child: container
    );
  }

}


class InnerShadowPainter extends CustomPainter {

  final Color color;
  final SizeVariant elevation;
  final SurfaceShape shape;
  final SizeVariant radius;
  final EdgeInsets padding;

  InnerShadowPainter({ required this.color, required this.elevation, required this.shape, required this.radius, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {

    final shadow = sizes.elevation.get(elevation) * 1.25; // adjusting shadow to looks like elevation
    final shadow2 = shadow / 2;

    final Paint shadowPaint = Paint()
      ..strokeWidth = shadow
      ..style = PaintingStyle.stroke
      ..imageFilter = ImageFilter.blur(sigmaX: shadow2, sigmaY:  shadow2)
      ..color = color;

    switch (shape) {

      case SurfaceShape.rectangle:
        canvas.drawRRect(RRect.fromLTRBR(-shadow2 - padding.left, -shadow2 - padding.top, size.width + shadow2 + padding.right, size.height + shadow2 + padding.bottom, sizes.radiusCircular.get(radius)), shadowPaint);
        break;
      case SurfaceShape.circle:
        final h = size.height + padding.top + padding.bottom;
        final w = size.width + padding.left + padding.right;
        canvas.drawCircle(Offset(w / 2 - padding.left,  h / 2 - padding.top), min(h, w) / 2, shadowPaint);
        break;
    }

  }

  @override
  bool shouldRepaint(InnerShadowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.elevation != elevation || oldDelegate.shape != shape || oldDelegate.radius != radius;
  }

}


class UniversalPlaceholder extends StatelessWidget {

  final Widget child;
  final SurfaceShape? shape;
  final SizeVariant? size;
  final SizeVariant? radius;
  final SizeVariant? elevation;
  final SizeVariant? padding;
  final PaddingType? paddingType;
  final AlignmentGeometry? textAlignment;
  final double? opacity;

  final HighlightColor? highlightColor;
  final void Function()? onTap;

  const UniversalPlaceholder({super.key, required this.child, this.radius, this.shape, this.elevation, this.padding, this.paddingType, this.textAlignment, this.size, this.highlightColor, this.onTap, this.opacity});

  @override
  Widget build(BuildContext context) {

    final s = UniversalSurfaceStyle.from(size: size, elevation: elevation, padding: padding, shape: shape, paddingType: paddingType, radius: radius, textAlignment: textAlignment);

    final p = sizes.insetsBy(s.paddingType, s.paddingSize);
    final clickable = onTap != null;
    final containerPadding = clickable ? EdgeInsets.zero : p;

    Widget child = this.child;

    if (p != EdgeInsets.zero) {
      child = Padding(padding: p, child: child);
    }

    child = child.withOpacity(opacity);

    if (clickable) {

      child = Material(
          elevation: 0.0,
          color: Colors.transparent,
          borderRadius: sizes.borderRadiusCircular.get(s.radiusSize),
          child: UniversalInkWell(
            hoverColor: Colors.transparent,
            highlightColor: highlightColor ?? HighlightColor.backgroundL2,
            radius: s.radiusSize,
            onTap: onTap,
            child: child,
          )
      );
    }

    final container = Container(
        padding: containerPadding,
        alignment: s.textAlignment,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: sizes.borderRadiusCircular.get(s.radiusSize)
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomPaint(
            painter: InnerShadowPainter(
                color: context.colors.elevationInner,
                elevation: s.elevationSize,
                radius: s.radiusSize,
                shape: s.shape,
                padding: containerPadding
            ),
            child: child
        )

    );

    return container;
  }



}