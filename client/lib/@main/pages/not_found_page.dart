
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';


class NotFoundPage extends StatelessWidget {

  const NotFoundPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundL1,
      child: const Center(child: Text("404")),
    );
  }
}
