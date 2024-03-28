

import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';


enum HighlightColor {

  backgroundL1,
  backgroundL2;

  Color of(BuildContext context) {

    final colors = context.colors;
    switch (this) {

      case HighlightColor.backgroundL1:
        return colors.backgroundL1;
      case HighlightColor.backgroundL2:
        return colors.backgroundL2;
    }
  }
}

class UniversalInkWell extends StatelessWidget {

  final Color? hoverColor;
  final HighlightColor? highlightColor;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final void Function(bool)? onFocusChange;
  final VoidCallback? onTap;
  final SizeVariant? radius;

  final Widget child;

  const UniversalInkWell({super.key, this.hoverColor, this.highlightColor, this.focusNode, this.canRequestFocus = true, this.onFocusChange, this.onTap, this.radius, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: hoverColor,
        focusColor: Colors.transparent,
        highlightColor: (highlightColor ?? HighlightColor.backgroundL1).of(context),
        splashColor: context.colors.secondary,
        borderRadius: sizes.borderRadiusCircular.get(radius ?? SizeVariant.base),

        focusNode: focusNode,
        canRequestFocus: canRequestFocus,
        onFocusChange: onFocusChange,
        onTap: onTap,
        child: child
    );
  }




}
