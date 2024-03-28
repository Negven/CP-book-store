
import 'package:client/service/_services.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';


class PagePlaceholder extends StatelessWidget {

  const PagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Services.modals.onWillPop,
      child: Empty.instance,
    );
  }

}
