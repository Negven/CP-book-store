

import 'package:client/@inf/inf_footer.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';


abstract class InfPage extends StatelessWidget {

  const InfPage({super.key});

  Color toSectionColor(BuildContext context, int index) {
    return index % 2 == 0 ? context.colors.backgroundL1 : context.color4background;
  }

  List<Widget> buildSections(BuildContext context);

  @override
  Widget build(BuildContext context) {

    final sections = buildSections(context);

    sections.add(InfFooter(
      color: toSectionColor(context, sections.length - 1)
    ));

    return SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(children: sections),
        )
    );
  }
}