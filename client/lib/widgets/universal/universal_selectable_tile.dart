

import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_ink_well.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';


class UniversalSelectableTile extends StatelessWidget {

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final FontIcon? leading;
  final FontIcon? trailing;
  final bool selected;

  const UniversalSelectableTile({super.key, required this.title, this.subtitle, this.onTap, this.leading, this.trailing, bool? selected}) : selected = selected ?? false;

  @override
  Widget build(BuildContext context) {

    final textColor = selected ? context.color4action : context.colors.text;
    final title = Text(this.title, style: context.texts.tileTitle, maxLines: 1, overflow: TextOverflow.ellipsis);

    Widget? texts;
    if (subtitle == null) {
      texts = Align(alignment: Alignment.centerLeft, child: title);
    } else {
      final subtitle = Opacity(opacity: 0.8, child: Text(this.subtitle!, style: context.texts.n.xs, maxLines: 1, overflow: TextOverflow.ellipsis));
      texts = Align(alignment: Alignment.centerLeft, child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            subtitle
          ]));
    }

    final height = sizes.selectableTileHeight;
    final leftPadding = leading != null ? height : sizes.paddingH.md;
    final rightPadding = trailing != null ? height : sizes.paddingH.md;

    final content = <Widget>[];

    if (leading != null) {
      content.add(Positioned(left: 0, top: 0, height: height, width: height, child: Center(child:leading!.fontIcon(size: SizeVariant.md))));
    }

    content.add(Padding(padding: EdgeInsets.only(left: leftPadding, right: rightPadding), child: texts));

    if (trailing != null) {
      content.add(Positioned(right: 0, top: 0, height: height, width: height, child: Center(child:trailing!.fontIcon(size: SizeVariant.md))));
    }

    final ink = UniversalInkWell(
      onTap: onTap,
      canRequestFocus: false,
      child: SizedBox(
        height: height,
        child: Stack(children: content),
      ),
    );

    return IconTheme.merge(
        data: IconThemeData(color: textColor),
        child: DefaultTextStyle.merge(style: TextStyle(color: textColor), child: ink)
    );

  }

}

