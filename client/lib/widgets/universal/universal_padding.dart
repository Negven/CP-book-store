

import 'package:client/classes/sizes.dart';
import 'package:flutter/material.dart';


class UniversalPadding extends StatelessWidget {

  final SizeVariant padding;
  final PaddingType paddingType;

  final Widget? child;

  const UniversalPadding({ super.key, this.padding = SizeVariant.base, this.paddingType = PaddingType.base, this.child });

  @override
  Widget build(BuildContext context) => Padding(
      padding: sizes.insetsBy(paddingType, padding),
      child: child
  );

}
