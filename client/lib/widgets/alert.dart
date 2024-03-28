import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/utils/string_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_color.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';


enum AlertType {

  text(ColorTheme.text, FontIcon.circleInfo),
  success(ColorTheme.success, FontIcon.circleCheck),
  primary(ColorTheme.primary, FontIcon.circleInfo),
  warning(ColorTheme.warning, FontIcon.triangleExclamation), // triangle is warning - from traffic signs
  danger(ColorTheme.danger, FontIcon.circleExclamation);

  final ColorTheme theme;
  final FontIcon icon;
  const AlertType(this.theme, this.icon);

}

class Alert extends StatelessWidget {

  final String? title;
  final String message;
  final AlertType type;
  final SizeVariant size;

  const Alert({super.key, this.title,  required this.message, this.type = AlertType.primary, this.size = SizeVariant.base });


  @override
  Widget build(BuildContext context) {

    final color = context.colors.resolveFlags(type.theme.borderColor, [isFocusedFlag]);

    final fontStyle = context.texts.n.get(size)
        .copyWith(color: Color.lerp(context.color4text, color, 0.25));

    final Widget text = StringUtils.isEmpty(title) ?
      Text(message, style: fontStyle)
        :
      Text.rich(
        TextSpan(
            children: [
              TextSpan(text: title, style: fontStyle.copyWith(fontVariations: VariableWeight.medium)),
              TextSpan(text: " $message", style: fontStyle),
            ]
        ));

    return Container(
      padding: sizes.insetsVH.get(size),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(sizes.radius.get(size)),
        border: Border.all(width: sizes.border.sm, color: color)
      ),
      child: Row(
        children: [
          type.icon.fontIcon(size: size, color: color),
          SizedBox(width: sizes.paddingH.get(size)),
          Flexible(child: text), // NB! Flexible is important to support text-wrapping
        ],
      ),
    );
  }
}
