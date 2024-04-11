
import 'dart:math';

import 'package:client/classes/sizes.dart';
import 'package:client/classes/types.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/error_utils.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:client/utils/widget_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/material/loading_indicator.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universal_color.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';


class ModalHeader extends StatelessWidget {

  final String title;
  const ModalHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: sizes.modalInsets,
            child: Text(title, style: context.texts.m.base)),
          const Spacer(),
          UniversalTextButton(icon: FontIcon.modalClose, padding: SizeVariant.md, paddingType: PaddingType.hh, onPressed: Services.modals.closeOne)
        ]
    );
  }

}


class ModalBody extends StatelessWidget {

  final SizeVariant? spaceSize;
  final Children children;
  final GlobalKey<FormState>? formKey;
  final CrossAxisAlignment? crossAxisAlignment;
  final double Function()? minHeight;

  const ModalBody({super.key, required this.children, this.formKey, this.spaceSize, this.minHeight, this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) {

    Widget content = Space.column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.stretch,
        mainAxisAlignment: minHeight != null ? MainAxisAlignment.center : null,
        size: spaceSize ?? SizeVariant.lg,
        children: children
    );

    if (minHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight!()),
        child: content,
      );
    }

    if (formKey != null) {
      return Form(
        key: formKey!,
        autovalidateMode: AutovalidateMode.disabled, // on demand
        child: content,
      );
    } else {
      return content;
    }
  }

  static ModalBody loading(BuildContext context, {String? message})  {
    return ModalBody(
        crossAxisAlignment: CrossAxisAlignment.center,
        minHeight: WidgetUtils.minModalContentSize,
        children: [
          const LoadingIndicator.circular(size: SizeVariant.xl),
          Text(message ?? '_loading'.T, style: context.texts.titleMedium, textAlign: TextAlign.center)
        ]);
  }

  static ModalBody success(BuildContext context, {required String message})  {
    return ModalBody(
        crossAxisAlignment: CrossAxisAlignment.center,
        minHeight: WidgetUtils.minModalContentSize,
        spaceSize: SizeVariant.sm,
        children: [
          ModalIcon(icon: message.hashCode % 2 == 0 ? Illustration.successMale : Illustration.successFemale, containerHeight: WidgetUtils.minModalContentSize),
          Text(message, style: context.texts.titleMedium, textAlign: TextAlign.center)
        ]);
  }

  static ModalBody error(BuildContext context, {String? message}) {
    return ModalBody(
      crossAxisAlignment: CrossAxisAlignment.center,
      minHeight: WidgetUtils.minModalContentSize,
      spaceSize: SizeVariant.sm,
      children: [
        const ModalIcon(icon: Illustration.unexpectedError, containerHeight: WidgetUtils.minModalContentSize),
        Text(ErrorUtils.toLocalizedMessage(message),
            style: context.texts.titleSmall!.copyWith(color: context.colors.resolveFlags(dangerTextUC, [isInactiveFlag])),
            textAlign: TextAlign.center
        )
    ]);
  }

}

class ModalIcon extends StatelessWidget {

  final Illustration icon;
  final double Function() containerHeight;

  const ModalIcon({super.key, required this.icon, required this.containerHeight});

  @override
  Widget build(BuildContext context) {
    final height = containerHeight() / 2;
    return context.toSvgLD(icon, height: height);
  }

}

class ModalFooter extends StatelessWidget {

  final bool inRow;
  final Children? fromStart;
  final Children? fromEnd;
  final SizeVariant? space;

  const ModalFooter({super.key, this.inRow = true, this.fromStart, this.fromEnd, this.space });

  static ModalFooter simpleNextBack({ String? back, Function()? onBack , String? next, Function()? onNext }) {
    return ModalFooter(
      fromEnd: [
        UniversalTextButton(text: '_continue'.T, onPressed: onNext),
        UniversalTextButton(text: '_back'.T, onPressed: onBack),
      ],
    );
  }

  static ModalFooter simpleCancel(Function() onPressed) {
    return ModalFooter(
      fromEnd: [
        UniversalTextButton(text: '_cancel'.T, onPressed: onPressed)
      ],
    );
  }

  static ModalFooter simpleOk() {
    return ModalFooter(
      fromEnd: [
        UniversalTextButton(text: '_ok'.T, onPressed: Services.modals.closeOne)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final children = <Widget>[];

    final crossAxisAlignment = inRow ? CrossAxisAlignment.center : CrossAxisAlignment.stretch;

    if (fromStart != null) {
      children.add(Space.dynamic(inRow: inRow, size: space, crossAxisAlignment: crossAxisAlignment, children: fromStart!));
    }

    if (inRow) {
      children.add(const Spacer());
    }

    if (fromEnd != null) {
      children.add(Space.dynamic(inRow: inRow, size: space, crossAxisAlignment: crossAxisAlignment, children: fromEnd!.reversed.toList()));
    }

    final child = inRow ? Row(
        children: children
      ) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
      )
    ;

    return Container(
      padding: inRow ? sizes.modalFooterRowInsets : sizes.modalFooterColumnInsets,
      decoration: BoxDecoration(
        border: Border(top: context.styles.disabledBorderSide)
      ),
      child: child
    );
  }


}



class Modal extends StatelessWidget {

  final SizeVariant? size;
  final String? title;
  final Widget? header;
  final Widget body;
  final Widget? footer;
  const Modal({super.key, required this.body, this.header, this.title, this.footer, this.size});

  static double width([SizeVariant? size]) {
    final maxWidth = 86.vw;
    return min(maxWidth, maxWidth.rR(md: sizes.modal.get(size ?? SizeVariant.base)));
  }

  @override
  Widget build(BuildContext context) {

    final children = <Widget?>[
      header ?? (title != null ? ModalHeader(title: title!) : null),
      Padding(padding: sizes.modalInsets, child: body),
      footer
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children.whereNotNull().toList(),
    );

    final material = Material(
        color: context.color4background,
        borderRadius: BorderRadius.all(sizes.radiusCircular.md),
        elevation: 0.0,
          child: content
    );


    return Container(
        width: width(size),
        margin: EdgeInsets.symmetric(vertical: 10.vMinR),
      child: material);
  }

}
