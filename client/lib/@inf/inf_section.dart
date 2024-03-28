

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/widgets/top_menu.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/widgets/section.dart';
import 'package:flutter/material.dart';



class InfSection extends ASection {


  InfSection._private();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Autowire(InfRoute.navigation),
      pageObx,
      const TopMenuScaffold()
    ],
  );

  static final ASection instance = InfSection._private();
}
