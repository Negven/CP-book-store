

import 'package:client/classes/sizes.dart';
import 'package:flutter/material.dart';


abstract class AppPage extends StatelessWidget {

  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: content(context)
    );
  }

  Widget content(BuildContext context);

}



class AppContent extends StatelessWidget {

  final Map<int, WidgetBuilder> builders;
  const AppContent(this.builders, {super.key});

  @override
  Widget build(BuildContext context) {

    for (var column = sizes.content.columns; column > 0; column--) {
      var builder = builders[column];
      if (builder != null) {
        return builder(context);
      }
    }

    throw 'Builder not found';
  }

}
