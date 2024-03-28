

import 'package:client/utils/font_utils.dart';
import 'package:flutter/material.dart';


abstract class SpendlyInfo {
  static const title = "Spendly";
  static const icon = "₴";
}


class SpendlyIcon extends StatelessWidget {

  final double height;
  late final TextStyle style;

  SpendlyIcon({super.key, required this.height, Color? color}) {
    style = TextStyle(
        fontSize: height * 1.35,
        height: 0.9,
        color: color,
        fontVariations: VariableWeight.medium
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: height * 1.1,
        height: height,
        child: DefaultTextStyle.merge(
            style: style,
            child: const Text(SpendlyInfo.icon, textAlign: TextAlign.left, maxLines: 1)
        ));
  }

}

enum SpendlyTitleAlign {
  baseline(0.85, 1.2, 3.65),
  fill(1.075, 0.91, 4.515);

  final double fontSizeK;
  final double fontHeightK;
  final double widthK;

  const SpendlyTitleAlign(this.fontSizeK, this.fontHeightK, this.widthK);
}

class SpendlyTitle extends StatelessWidget {

  final double height;
  final double width;
  late final TextStyle style;

  SpendlyTitle({super.key, required this.height, SpendlyTitleAlign align = SpendlyTitleAlign.fill}) : width = height * align.widthK {
    style = TextStyle(
        fontSize: height * align.fontSizeK,
        height: align.fontHeightK,
        fontVariations: VariableWeight.bold
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ClipRect(child: DefaultTextStyle.merge(
            style: style,
            child: const Text(SpendlyInfo.title, textAlign: TextAlign.left, maxLines: 1, overflow: TextOverflow.visible)
        )));
  }


}


class Spendly extends StatelessWidget {

  final double height;
  const Spendly({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SpendlyIcon(height: height),
        SizedBox(width: height / 3, height: height),
        SpendlyTitle(height: height * 0.8, align: SpendlyTitleAlign.baseline)
      ]
    );
  }

}