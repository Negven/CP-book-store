
import 'package:flutter/material.dart';


class Empty extends StatelessWidget {

  const Empty({super.key});

  @override
  Widget build(BuildContext context) => Empty.instance;


  // Most optimized widget to render placeholders
  static const instance = SizedBox.shrink();
}