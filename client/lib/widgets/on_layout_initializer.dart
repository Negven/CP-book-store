
import 'package:flutter/material.dart';


class OnLayoutBuild extends StatelessWidget {

  final Widget child;
  final Function(BoxConstraints) listener;

  const OnLayoutBuild({
    required this.child,
    required this.listener,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {

        if (constraints.maxWidth > 0 && constraints.maxHeight > 0) {
          listener.call(constraints);
          return child;
        }

        return Container();
      },
    );
  }
}
