

import 'package:client/classes/sizes.dart';
import 'package:client/classes/types.dart';
import 'package:flutter/cupertino.dart';

class Space extends StatelessWidget {

  final bool inRow;
  final SizeVariant? size;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final Children children;

  const Space.dynamic({ super.key, required this.inRow, this.size, this.crossAxisAlignment, this.mainAxisAlignment, required this.children });

  const Space.row({ super.key, this.size, this.crossAxisAlignment, this.mainAxisAlignment, required this.children }) : inRow = true;

  const Space.column({ super.key, this.size, this.crossAxisAlignment, this.mainAxisAlignment, required this.children }) : inRow = false;

  @override
  Widget build(BuildContext context) {

    final size = this.size ?? SizeVariant.base;
    final crossAxisAlignment = this.crossAxisAlignment ?? CrossAxisAlignment.center;

    final spaceBox = size.isNone ? null : inRow ? sizes.sizedBoxH.get(size) : sizes.sizedBoxV.get(size);

    List<Widget> children = [];

    for (var child in this.children) {

      if (children.isNotEmpty && spaceBox != null) {
        children.add(spaceBox);
      }

      children.add(child);
    }

    if (inRow) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: children
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: children
    );
  }



}