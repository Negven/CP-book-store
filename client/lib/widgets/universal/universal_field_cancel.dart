import 'package:client/classes/types.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/modal.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:flutter/material.dart';

export 'package:client/widgets/universal/universal_query.dart';


class UniversalFieldModalFooter extends StatelessWidget {

  final bool showCancel;
  final void Function(BuildContext, Children)? fromEnd;
  final void Function(BuildContext, Children)? fromStart;

  const UniversalFieldModalFooter({super.key, this.showCancel = true, this.fromEnd, this.fromStart});

  @override
  Widget build(BuildContext context) {

    final Children fromStart = [];
    if (this.fromStart != null) {
      this.fromStart!(context, fromStart);
    }

    final Children fromEnd = [if (showCancel) UniversalTextButton(text: '_cancel'.T, onPressed: () => UniversalFieldContext.trigger(context, UniversalEvent.closeModal))];
    if (this.fromEnd != null) {
      this.fromEnd!(context, fromEnd);
    }

    return ModalFooter(
      fromEnd: fromEnd,
      fromStart: fromStart,
    );
  }

}
