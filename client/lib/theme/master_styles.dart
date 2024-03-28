
import 'package:client/classes/sizes.dart';
import 'package:client/theme/master_colors.dart';
import 'package:client/theme/master_texts.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/widgets/universal/universal_button_style.dart';
import 'package:client/widgets/universal/universal_color.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

export 'package:client/widgets/universal/universal_button_style.dart';


const transparentMs = MaterialStatePropertyAll(Colors.transparent);
const elevationZeroMs = MaterialStatePropertyAll(0.0);

// Style will be shown everywhere where not used themed components
const neverActiveStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.red),
    foregroundColor: MaterialStatePropertyAll(Colors.pink),
    padding: MaterialStatePropertyAll(EdgeInsets.all(999.0))
);


class MasterTemplates {

  final Brightness brightness;
  final MasterTexts texts;
  final MasterColors colors;

  MasterTemplates(this.brightness, this.texts, this.colors);

  final contentAction = UniversalTemplate(
    type: SurfaceType.text,
    theme: ColorTheme.text,
    textWeight: TextWeight.normal
  );

  final menuCircleButton = UniversalTemplate(
    type: SurfaceType.text,
    theme: ColorTheme.text,
    shape: SurfaceShape.circle,
  );

  late final verticalButton = UniversalTemplate(
    theme: ColorTheme.primary,
    textColor: textUC,
    layoutOrientation: LayoutOrientation.vertical
  );

  late final whiteButton = UniversalTemplate(
    type: SurfaceType.outlined,
    theme: ColorTheme.text,
    textColor: blackTextUC, // with opacity
    backgroundColor: whiteBackgroundUC,
    borderColor: whiteBorderUC,
    borderSize: SizeVariant.sm,
    overlayColor: whiteOverlayUC.sm
  );

}




class MasterStyles extends ThemeExtension<MasterStyles> {

  final double factor;
  final Brightness brightness;
  final MasterColors colors;
  final MasterTexts texts;

  MasterStyles._private(this.brightness, this.factor, this.colors, this.texts);

  static MasterStyles from(Brightness brightness, double factor) {
    final colors = MasterColors.colors[brightness]!;
    final texts = MasterTexts.from(factor, colors);
    return MasterStyles._private(brightness, factor, colors, texts);
  }


  late final templates = MasterTemplates(brightness, texts, colors);
  late final _theme = ThemeData.from(colorScheme: colors, textTheme: texts);

  late final borderRadiusSm = sizes.borderRadiusCircular.sm;
  late final buttonShapeSm = sizes.roundedRectangleBorder.sm;

  static const defaultPaddingSize = SizeVariant.base;

  static const transparentBorder = BorderSide(color: Colors.transparent, width: 0.0);

  late final dividerSide = BorderSide(color: colors.resolveColor(primaryDividerUC), width: sizes.border.sm);
  late final dividerBorderRL = Border(right: dividerSide, left: dividerSide);

  late final dividerSide2 = BorderSide(color: colors.resolveColor(onTextDividerUC).withOpacity(O.verticalMenuBorder), width: sizes.border.sm);
  late final dividerBorderRL2 = Border(right: dividerSide2, left: dividerSide2);


  late final enabledBorderSide = BorderSide(color: colors.resolveColor(primaryBorderUC), width: sizes.border.sm);
  late final enabledBorder = OutlineInputBorder(borderSide: enabledBorderSide, borderRadius: borderRadiusSm);

  late final focusedBorderSide = BorderSide(color: colors.resolveFlags(primaryBorderUC, [isFocusedFlag]), width: sizes.border.md);
  late final focusedBorder = OutlineInputBorder(borderSide: focusedBorderSide, borderRadius: borderRadiusSm);

  late final disabledBorderSide = BorderSide(color: colors.resolveFlags(textBorderUC, [isDisabledFlag]), width: sizes.border.sm);
  late final disabledBorder = OutlineInputBorder(borderSide: disabledBorderSide, borderRadius: borderRadiusSm);

  late final errorBorderSide = BorderSide(color: colors.resolveColor(dangerBorderUC), width: sizes.border.sm);
  late final errorBorder = OutlineInputBorder(borderSide: errorBorderSide, borderRadius: borderRadiusSm);

  late final errorFocusedBorderSide = BorderSide(color: colors.resolveFlags(dangerBorderUC, [isFocusedFlag]), width: sizes.border.md);
  late final errorFocusedBorder = OutlineInputBorder(borderSide: errorFocusedBorderSide, borderRadius: borderRadiusSm);

  static const minimumSize = Size(1.0, 1.0);

  late final buttonTheme = _theme.buttonTheme.copyWith(
      minWidth: minimumSize.width,
      height: minimumSize.height,
      padding: sizes.insetsVH.get(defaultPaddingSize),
      shape: buttonShapeSm
  );

  final Map<int, ButtonStyle> _cachedButtonStyles = {};


  SizedValue<TextStyle> styleFrom(TextWeight weight) {
    switch (weight) {
      case TextWeight.normal:
        return texts.n;
      case TextWeight.medium:
        return texts.m;
      case TextWeight.bold:
        return texts.b;
      case TextWeight.extra:
        return texts.e;
      case TextWeight.ultra:
        return texts.u;
    }
  }

  ButtonStyle buildFrom(UniversalButtonStyle setting) {

    final cached = _cachedButtonStyles[setting.hashCode];
    if (cached != null) return cached;

    final style = OutlinedButton.styleFrom(
        minimumSize: minimumSize,
        padding: EdgeInsets.zero,
        textStyle: styleFrom(setting.textWeight).get(setting.textSize)
    ).copyWith(
      shadowColor: setting.elevationSize.isNone ? transparentMs : setting.resolveWith(buttonElevationColor),
      elevation: setting.elevationSize.isNone ? elevationZeroMs : setting.resolveWith(buttonElevation),
      foregroundColor: setting.resolveWith(buttonTextColor),
      backgroundColor: setting.resolveWith(buttonBackgroundColor),
      side: setting.resolveWith(buttonBorderSide),
      shape: setting.resolveWith(buttonShape),
      overlayColor: setting.resolveWith(buttonOverlayColor)
    );

    _cachedButtonStyles[setting.hashCode] = style;

    return style;
  }

  OutlinedBorder buttonShape(UniversalButtonStyle setting, Set<MaterialState> states)
    => sizes.shapeBy(setting.shape, setting.radiusSize);


  BorderSide buttonBorderSide(UniversalButtonStyle setting, Set<MaterialState> states)
    => surfaceBorderSide(setting.borderSize, setting.borderColor, setting.strokeAlignment, states.isActive, states.isFocused);


  UniversalFlags _toFlags(bool isDisabled, bool? isFocused, [SurfaceType? type]) => flags()
      .toggle(isDisabled, isDisabledFlag)
      .toggle(isFocused, isFocusedFlag)
      .toggle(type?.isFilled, isOnFlag);


  BorderSide surfaceBorderSide(SizeVariant border, Color borderColor, StrokeAlignment strokeAlignment, bool isActive, bool isFocused) {

    if (border.isNone) {
      return transparentBorder;
    }

    return BorderSide(color: colors.resolveFlags(borderColor, _toFlags(!isActive, isFocused)), width: sizes.border.get(border), strokeAlign: strokeAlignment.value);
  }

  Color buttonElevationColor(UniversalButtonStyle setting, Set<MaterialState> states) =>
      surfaceElevationColor(setting.type, setting.elevationSize, states.isActive, states.isFocused);

  Color surfaceElevationColor(SurfaceType type, SizeVariant elevation, bool isActive, [bool? isFocused]) =>
    elevation.isNone ? Colors.transparent : colors.resolveFlags(elevationUC, _toFlags(!isActive, isFocused, type));

  double buttonElevation(UniversalButtonStyle setting, Set<MaterialState> states) =>
      (setting.elevationSize.isNone || states.isDisabled || states.isPressed) ? 0.0 : sizes.elevation.get(setting.elevationSize);

  Color buttonTextColor(UniversalButtonStyle setting, Set<MaterialState> states) =>
      buttonForegroundColor(setting, states, setting.textColor);

  Color buttonOverlayColor(UniversalButtonStyle setting, Set<MaterialState> states) =>
      colors.resolveFlags(setting.overlayColor, _toFlags(states.isDisabled, states.isFocused, setting.type));

  Color buttonForegroundColor(UniversalButtonStyle setting, Set<MaterialState> states, Color foregroundColor) =>
      surfaceForegroundColor(setting.type, foregroundColor, states.isActive, states.isFocused);

  Color surfaceForegroundColor(SurfaceType type, Color foregroundColor, bool isActive, [bool? isFocused]) =>
      colors.resolveFlags(foregroundColor, _toFlags(!isActive, isFocused, type));

  Color buttonBackgroundColor(UniversalButtonStyle setting, Set<MaterialState> states)
    => surfaceBackgroundColor(setting.type, setting.backgroundColor, buttonElevationColor(setting, states), states.isActive, colors.backgroundL0, states.isFocused);

  Color surfaceBackgroundColor(SurfaceType type, Color backgroundColor, Color elevationColor, bool isActive, Color fallbackColor, [bool? isFocused]) {
    var result = colors.resolveFlags(backgroundColor, _toFlags(!isActive, isFocused, type));
    return elevationColor != Colors.transparent && result == Colors.transparent ? fallbackColor : result;
  }


  late final popupMenuTheme = _theme.popupMenuTheme.copyWith(
      shape: buttonShapeSm,
      elevation: sizes.elevation.sm,
      shadowColor: colors.shadow,
      surfaceTintColor: colors.surfaceTint,
      textStyle: texts.labelMedium
  );

  late final inputDecorationTheme = InputDecorationTheme(
    contentPadding: sizes.insetsHH.get(defaultPaddingSize), // as input will have border with label
    enabledBorder: enabledBorder,
    disabledBorder: disabledBorder,
    errorBorder: errorBorder,
    focusedBorder: focusedBorder,
    focusedErrorBorder: errorFocusedBorder,
  );

  late final dividerTheme = DividerThemeData(
      thickness: sizes.border.sm,
      space: 0, // Making divider take 0 space by default ot easily adjust UI layout (see date picker)
      indent: 0,
      endIndent: 0,
      color: colors.resolveColor(primaryDividerUC)
  );

  late final theme = _theme.copyWith(
      brightness: brightness,
      extensions: [this],
      colorScheme: colors,
      inputDecorationTheme: inputDecorationTheme,
      dividerColor: dividerTheme.color,
      dividerTheme: dividerTheme,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // NB! Must be shrinkWrap, as padded makes tappable elements be at least 48px x 48px
      buttonTheme: buttonTheme,
      elevatedButtonTheme: const ElevatedButtonThemeData(style: neverActiveStyle),
      outlinedButtonTheme: const OutlinedButtonThemeData(style: neverActiveStyle),
      textButtonTheme: const TextButtonThemeData(style: neverActiveStyle),
      iconButtonTheme: const IconButtonThemeData(style: neverActiveStyle),
      popupMenuTheme: popupMenuTheme,
      tooltipTheme: _theme.tooltipTheme.copyWith(
        decoration: BoxDecoration(
          color: colors.text.withOpacity(O.tooltip),
          borderRadius: sizes.borderRadiusCircular.sm
        ),
        textStyle: texts.n.xxs.copyWith(color: colors.onText.withOpacity(O.tooltip)),
        padding: sizes.insetsVH.xxs,
        waitDuration: const Duration(milliseconds: 500)
      ),
      chipTheme: _theme.chipTheme.copyWith(
        padding: sizes.insetsVH.sm,
        labelPadding: EdgeInsets.zero,
        labelStyle: texts.m.xs
      ),
      iconTheme: IconThemeData(
          size: sizes.icon.base,
          opacity: O.icon
      ),
      listTileTheme: _theme.listTileTheme.copyWith(
        shape: buttonShapeSm
      ),
  );

  late final markdown = MarkdownStyleSheet(
    a: TextStyle(color: colors.primary),
    p: texts.n.base,
    pPadding: sizes.insetsHeadings.xxs,
    h1: texts.m.xxl,
    h1Padding: sizes.insetsHeadings.lg,
    h2: texts.m.xl,
    h2Padding: sizes.insetsHeadings.md,
    h3: texts.b.lg,
    h3Padding: sizes.insetsHeadings.sm,
    h4: texts.b.md,
    h4Padding: sizes.insetsHeadings.xs,
    h5: texts.b.sm,
    h5Padding: sizes.insetsHeadings.xxs,
    h6: texts.b.xs,
    h6Padding: EdgeInsets.zero,
    em: const TextStyle(fontStyle: FontStyle.italic),
    strong: const TextStyle(fontVariations: VariableWeight.bold, fontWeight: FontWeight.normal),
    del: const TextStyle(decoration: TextDecoration.lineThrough),
    img: texts.m.sm,
    checkbox: theme.textTheme.bodyMedium!.copyWith(
      color: colors.primary,
    ),
    blockSpacing: sizes.paddingV.base,
    listIndent: sizes.paddingH.md,
    listBullet: theme.textTheme.bodyMedium,
    listBulletPadding: EdgeInsets.only(right: sizes.paddingV.xs),
    tableHead: texts.b.base,
    tableBody: texts.n.base,
    tableHeadAlign: TextAlign.center,
    tableBorder: TableBorder.all(
      color: theme.dividerColor,
      width: sizes.border.base,
      borderRadius: sizes.borderRadiusCircular.base
    ),
    tableColumnWidth: const FlexColumnWidth(),
    tableCellsPadding:  sizes.insetsVH.base,
    tableCellsDecoration: const BoxDecoration(),
    blockquote: theme.textTheme.bodyMedium,
    blockquotePadding: sizes.insetsHH.xs,
    blockquoteDecoration: BoxDecoration(
      color: colors.text.withOpacity(O.markdownBlock),
      borderRadius: sizes.borderRadiusCircular.base,
    ),
    code: texts.m.xs.copyWith(
      backgroundColor: Colors.transparent,
      fontFamily: 'monospace'
    ),
    codeblockPadding: sizes.insetsVH.base,
    codeblockDecoration: BoxDecoration(
      color: colors.text.withOpacity(O.markdownBlock),
      borderRadius: sizes.borderRadiusCircular.base,
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          width: sizes.border.base,
          color: theme.dividerColor,
        ),
      ),
    ),
  );

  @override
  ThemeExtension<MasterStyles> copyWith() {
    return this;
  }

  @override
  ThemeExtension<MasterStyles> lerp(covariant ThemeExtension<MasterStyles>? other, double t) {
    return this;
  }

}



