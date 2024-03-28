
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

    final page = _builder.value();

    // Transferring current walletId to all inner children
    // final child = WalletContext(
    //   walletId: Services.navigation.nCurrentWalletId,
    //   child: page,
    // );
    final child = _builder.value();

    return Interlayer(
        // NB! Making sure to re-render whole page with state on navigation
        // Mainly needed when context of page changed, bug page not, going from wallet/id1/overview to wallet/id2/overview
        key: _sectionPageKey.value,
        child: child
      );
  });

  void setPage([PageBuilder nextPageBuilder = Empty.new]) {
    // NB! Making sure to re-render whole page with state on navigation
    // Mainly needed when context of page changed, bug page not, like going from wallet/id1/overview to wallet/id2/overview
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


