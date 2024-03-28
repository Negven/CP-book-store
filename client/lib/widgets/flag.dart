import 'package:client/enum/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Flag extends StatelessWidget {

  final CountryCode countryCode;

  final double? height;
  final double? width;

  final BoxFit fit;

  final Widget loading;

  final double? borderRadius;

  const Flag.fromCode(
      this.countryCode, {
        super.key,
        this.height,
        this.width,
        this.fit = BoxFit.contain,
        this.loading = const SizedBox.shrink(),
        this.borderRadius,
      });

  @override
  Widget build(BuildContext context) {

    String country = countryCode.name.toLowerCase();
    String assetName = 'flags/$country.svg';

    final returnWidget = SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        assetName,
        semanticsLabel: country,
        fit: fit,
        placeholderBuilder: (_) => loading,
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: returnWidget,
      );
    } else {
      return returnWidget;
    }
  }

}
