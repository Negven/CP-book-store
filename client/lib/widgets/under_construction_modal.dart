
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/widget_utils.dart';
import 'package:client/widgets/modal.dart';
import 'package:flutter/material.dart';


class UnderConstructionModal extends StatelessWidget {

  final String title;
  const UnderConstructionModal({super.key, required this.title});

  @override
  Widget build(BuildContext context) =>
    Modal(
      title: title,
      footer: ModalFooter.simpleOk(),
        body: ModalBody(
            crossAxisAlignment: CrossAxisAlignment.center,
            minHeight: WidgetUtils.minModalContentSize,
            spaceSize: SizeVariant.sm,
            children: [
              const ModalIcon(icon: Illustration.underConstruction, containerHeight: WidgetUtils.minModalContentSize),
              Text('_underConstruction'.T, style: context.texts.titleMedium, textAlign: TextAlign.center)
            ]),
    );


}
