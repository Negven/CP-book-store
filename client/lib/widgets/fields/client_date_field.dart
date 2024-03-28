

import 'package:client/classes/sized_value.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/date_time_utils.dart';
import 'package:client/widgets/modal.dart';
import 'package:client/widgets/universal/date_picker/universal_date_picker.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';

class UniversalClientDate extends UniversalItem<ClientDate> {

  UniversalClientDate(super.value);

  UniversalClientDate.from(DateTime dateTime) : super(ClientDate.from(dateTime));

  @override
  String get title => value.format();


  static UniversalClientDate? select(DateTime? dateTime) => dateTime == null ? null : UniversalClientDate.from(dateTime);
}

class ClientDateField extends StatelessWidget {

  final String title;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? resetDate;
  final String? placeholder;
  final UniversalController<UniversalClientDate> controller;
  final String? Function(UniversalClientDate?)? validator;

  const ClientDateField(this.controller, {super.key, this.resetDate, required this.title, this.placeholder, this.validator, required this.firstDate, required this.lastDate});

  Modal _toModal(BuildContext context) {

    final picker = UniversalDatePicker(
        value: [if (controller.value != null) controller.value!.value ],
        firstDate: firstDate,
        lastDate: lastDate,
        onValueChanged: (context, dates) {
          UniversalFieldContext.closeWith(context, UniversalClientDate.select(dates.firstOrNull));
        }
    );

    return Modal(
      size: SizeVariant.xs,
      title: placeholder ?? title,
      body: ModalBody(
        children: [
          picker
        ],
      ),
      footer: UniversalFieldModalFooter(
        fromEnd: (context, widgets) {
          widgets.add(UniversalTextButton(text: '_reset'.T, onPressed: () => UniversalFieldContext.closeWith(context, UniversalClientDate.select(resetDate))));
        },
      ),

    );

  }

  @override
  Widget build(BuildContext context) {
    return UniversalField<UniversalClientDate>(
        title: title,
        placeholder: placeholder,
        controller: controller,
        toModal: (f) => _toModal(context),
        validator: validator
    );
  }

}


