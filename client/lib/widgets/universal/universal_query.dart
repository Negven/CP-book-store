import 'package:client/classes/debounce_value.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/string_utils.dart';
import 'package:client/widgets/material/materials.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum AutofocusMode {

  auto(null),
  on(true),
  off(false);

  final bool? _active;
  const AutofocusMode(this._active);

  // autofocus forces to screen keyboard opens, don't needed that on mobile devices
  bool get autofocus => _active ?? !GetPlatform.isMobile;
}

class UniversalQuery extends StatefulWidget {

  final AutofocusMode autofocus;
  final String? query;
  final Function(String query) onChange;

  const UniversalQuery({super.key, this.query, required this.onChange, this.autofocus = AutofocusMode.auto });

  @override
  State<StatefulWidget> createState() => UniversalQueryState();

}

class UniversalQueryState extends UtilizableState<UniversalQuery> {

  late final TextEditingController controller;
  late final DebounceValue<String> debounceQuery;

  @override
  void initState() {
    super.initState();
    final query = widget.query ?? "";
    final text = StringUtils.isEmpty(query) ? TextEditingValue(text: query) : TextEditingValue(text: query, selection: TextSelection(baseOffset: 0, extentOffset: query.length));
    controller = u(TextEditingController.fromValue(text));
    debounceQuery = u(DebounceValue<String>(query, onQueryChange));
    controller.addListener(() => debounceQuery.setValue(controller.value.text));
  }

  onQueryChange(String query) {
    widget.onChange(query);
  }

  @override
  Widget build(BuildContext context) {
    return Materials.textFormField(context,
        labelText: '_search'.T,
        controller: controller,
        focusNode: FocusNode(
            onKeyEvent: (node, event) => UniversalFieldContext.onKeyEvent(context, event)
        ),
        autofocus: widget.autofocus.autofocus,
        onFieldSubmitted: (_) => UniversalFieldContext.submit(context)
    );
  }

}

