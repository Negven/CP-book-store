

import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {

  final SizeVariant size;
  final SizeVariant stroke;
  final Color? color;
  final SurfaceShape shape;
  final SizeVariant? radius;
  final bool hidden;

  const LoadingIndicator.rectangle({super.key, required this.size, this.color, SizeVariant? radius, this.hidden = false})
      : shape = SurfaceShape.rectangle, stroke = size, radius = radius ?? size;

  const LoadingIndicator.circular({super.key, required this.size, this.color, this.hidden = false, SizeVariant? stroke})
      : shape = SurfaceShape.circle, radius = null, stroke = stroke ?? size;

  @override
  Widget build(BuildContext context) {

    final stroke = sizes.progressIndicatorStroke.get(this.stroke);
    final color = this.color ?? context.styles.colors.primary;
    final backgroundColor = color.withOpacity(color.opacity * 0.2);

    switch (shape) {

      case SurfaceShape.rectangle:

        final indicator = hidden ? Empty.instance : LinearProgressIndicator(
          backgroundColor: backgroundColor,
          color: color,
          minHeight: stroke,
          borderRadius: sizes.borderRadiusCircular.tryGet(radius, BorderRadius.zero),
        );

        return SizedBox(
          height: stroke,
          child: indicator,
        );

      case SurfaceShape.circle:

        final indicator = hidden ? Empty.instance : CircularProgressIndicator(
            backgroundColor: backgroundColor,
            color: color,
            strokeWidth: stroke,
            strokeAlign: -1.0
        );

        final size = sizes.progressIndicatorSize.get(this.size);

        return SizedBox(
            width: size,
            height: size,
            child: indicator
        );
    }

  }

}