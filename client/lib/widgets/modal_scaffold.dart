
import 'package:client/widgets/page_builder.dart';
import 'package:flutter/material.dart';


class ModalScaffold extends StatelessWidget {

  final PageBuilder builder;
  const ModalScaffold(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ builder.call() ]
          ))
        ]);
  }

}
