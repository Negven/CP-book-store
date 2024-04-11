
import 'package:client/classes/value.dart';
import 'package:client/service/_services.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final _sectionPageKey = V(UniqueKey());

abstract class ASection extends StatelessWidget {

  ASection({super.key});

  final _builder = Rx<PageBuilder>(Empty.new);
  late final Obx pageObx = Obx(() {
    final child = _builder.value();

    return Interlayer(
        key: _sectionPageKey.value,
        child: child
      );
  });

  void setPage([PageBuilder nextPageBuilder = Empty.new]) {
    _sectionPageKey.value = UniqueKey();
    _builder.trigger(nextPageBuilder);
  }

}

class Interlayer extends StatelessWidget {

  final Widget child;
  const Interlayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;

}


class EmptySection extends ASection {

  EmptySection._private();

  @override
  Widget build(BuildContext context) {
    return pageObx;
  }

  static final ASection instance = EmptySection._private();

}


