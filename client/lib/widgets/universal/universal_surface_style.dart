
import 'package:client/classes/sizes.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:flutter/material.dart';


class UniversalSurfaceStyle extends UniversalTemplate {

  @override SurfaceType get type => super.type!;
  @override SizeVariant get elevationSize => super.elevationSize!;
  @override SizeVariant get size => super.size!;
  @override ColorTheme get theme => super.theme!;
  @override Color get textColor => super.textColor!;
  @override Color get borderColor => super.borderColor!;
  @override Color get backgroundColor => super.backgroundColor!;
  @override SizeVariant get radiusSize => super.radiusSize!;
  @override SurfaceShape get shape => super.shape!;
  @override SizeVariant get paddingSize => super.paddingSize!;
  @override SizeVariant get borderSize => super.borderSize!;
  @override PaddingType get paddingType => super.paddingType!;
  @override StrokeAlignment get strokeAlignment => super.strokeAlignment!;
  // alignment can be nullable

  UniversalSurfaceStyle._private({
    required super.theme,
    required super.textColor,
    required super.borderColor,
    required super.backgroundColor,
    required super.shape,
    required super.type,
    required super.size,
    required super.paddingSize,
    required super.borderSize,
    required super.elevationSize,
    required super.radiusSize,
    required super.paddingType,
    required super.textAlignment,
    required super.strokeAlignment,
  });

  static UniversalSurfaceStyle from({
      SurfaceType? type,
      SizeVariant? elevation,
      SizeVariant? size,
      SizeVariant? radius,
      SizeVariant? padding,
      SizeVariant? border,
      ColorTheme? theme,
      Color? textColor,
      Color? borderColor,
      Color? backgroundColor,
      SurfaceShape? shape,
      PaddingType? paddingType,
      AlignmentGeometry? textAlignment,
      StrokeAlignment? strokeAlignment,
      UniversalTemplate? template
    }) {

    ColorTheme t = defaultOf.theme(theme, template);
    SizeVariant s = defaultOf.size(size, template);

    return UniversalSurfaceStyle._private(
        theme: t,
        textColor: defaultOf.textColor(textColor, template, t),
        borderColor: defaultOf.borderColor(borderColor, template, t),
        backgroundColor: defaultOf.backgroundColor(backgroundColor, template, t),
        size: s,
        elevationSize: SizeVariant.nvl(elevation, template?.elevationSize),
        paddingSize: padding ?? template?.paddingSize ?? SizeVariant.none, // NB! Main difference
        type: type ?? template?.type ?? SurfaceType.text, // NB! Main difference
        borderSize: border ?? template?.borderSize ?? (type == SurfaceType.outlined ? s : SizeVariant.none),
        shape: shape ?? template?.shape ?? SurfaceShape.base,
        textAlignment: textAlignment ?? template?.textAlignment,
        strokeAlignment: strokeAlignment ?? template?.strokeAlignment ?? StrokeAlignment.base,
        radiusSize: radius ?? template?.radiusSize ?? s,
        paddingType: paddingType ?? template?.paddingType ?? PaddingType.base
    );

  }

}

