

import 'dart:math';

import 'package:client/classes/sizes.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class CenteredContent extends StatelessWidget {

  final Widget child;

  const CenteredContent({super.key, required this.child});

  static double get width => min(sizes.sCR, ScreenWidth.now.size);

  @override
  Widget build(BuildContext context) {

    if (ScreenWidth.now <= ScreenWidth.xl) {
      return child;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: width, child: child)
        ]
    );

  }

}
