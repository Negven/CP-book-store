import 'package:client/classes/sized_value.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/service/_services.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/sequence_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/material/materials.dart';
import 'package:client/widgets/modal.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:client/widgets/universal/universal_ink_well.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:client/widgets/universal/universal_field_cancel.dart';
export 'package:client/widgets/universal/universal_query.dart';
export 'package:client/widgets/universal/universal_selectable_list.dart';
export 'package:client/widgets/universal/universal_selectable_tile.dart';


typedef ItemToInput<I> = Widget? Function(I item);
typedef ItemToModal<I extends UniversalItem> = Modal Function(UniversalField<I> field);


enum SubmitType {
  none,
  enter,
  metaEnter
}

class UniversalController<I extends UniversalItem> extends Rxn<I> {

  bool loading = false;

  // forcing re-render of field on load
  void loaded(I? loaded) {

    loading = false;

    if (value != loaded) {
      value = loaded;
    } else {
      if (loaded != null) {
        value!.assignFrom(loaded);
      }
      refresh();
    }
  }

  UniversalController([I? value, void Function(I? value)? listener]) : super(value) {
    if (listener != null) {
      listen(listener);
      if (value != null) listener(value);
    }
  }


}

abstract class UniversalMapper<T, I extends UniversalItem> {

  final UniversalController<I> originController;
  final I Function(T) mapper;
  final bool isActive;

  UniversalMapper(this.originController, this.mapper, this.isActive);

  I? map(T? value) {
    if (value == null) return null;
    return this.mapper(value);
  }

}

class TextUniversalMapper<I extends UniversalItem> extends UniversalMapper<String, I> {

  final textController = TextEditingController();

  TextUniversalMapper(super.originController, super.mapper, super.isActive) {
    if (isActive) {
      textController.addListener(() => originController.loaded(map(textController.text)));
    }
  }


}


class UniversalField<I extends UniversalItem> extends StatefulWidget {

  final UniversalController<I> controller;
  final ItemToInput<I>? toInput;
  final ItemToModal<I> toModal;
  final FormFieldValidator<I>? validator;
  final Function(I)? _onSelect;

  final String title;
  final String placeholder;
  final SubmitType submitType;
  final bool? enabled;

  const UniversalField({super.key,
    required this.title,
    required this.toModal,
    required this.controller,
    dynamic Function(I)? onSelect,
    this.toInput,
    this.submitType = SubmitType.enter,
    this.validator,
    String? placeholder,
    this.enabled}) :
        _onSelect = onSelect,
        placeholder = placeholder ?? title;

  I? get selected => controller.value;

  @override
  State<StatefulWidget> createState() {
    return UniversalFieldState<I>();
  }

}


class UniversalFieldState<I extends UniversalItem> extends UtilizableState<UniversalField<I>> {

  final stateId = SequenceUtils.nextInt;

  final FocusNode _widgetFocusNode = FocusNode();
  final isFocused = false.obs;
  late final Rxn<String> errorText;
  late final Rx<bool> enabled;

  @override
  void initState() {
    super.initState();
    errorText = u(Rxn());
    enabled = u((widget.enabled ?? true).obs);

    listenUniversal((e, payload) {
      switch (e) {
        case UniversalEvent.closeModal:
          closeModal();
          break;
        case UniversalEvent.closeWith:
          closeWith(payload as I?);
          break;
        default:
          break;
      }

    }, stateId);
  }

  onSelect(I item) {
    if (widget._onSelect != null) widget._onSelect!(item);
  }

  late final isModalShown = u(false.obs);

  openModal() async {

    isModalShown.value = true;

    await Services.modals.showModal(() => UniversalFieldContext(
        stateId: stateId,
        selectedItem: widget.controller.value,
        submitType: widget.submitType,
        child: widget.toModal(widget)
    ));

    isModalShown.value = false;

    CallUtils.defer(requestFocus);
  }


  closeModal() {
    if (isModalShown.value) {
      Services.modals.closeOne();
    }
  }

  closeWith(I? nextItem) {
    widget.controller.value = nextItem;
    if (nextItem != null) onSelect(nextItem);
    closeModal();
  }

  requestFocus() {
    _widgetFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {

    final toInput = widget.toInput;
    final input = Obx(() {

      final item = widget.controller.value;
      if (widget.controller.loading) {
        return Materials.inputLoading(context, title: widget.title);
      }

      final inputWidget = item == null ? null : (toInput == null ? Materials.toInputText(context, item.title) : toInput(item));
      final isFocused = this.isFocused.value;

      final decorator = Materials.inputDecorator(context,
          title: widget.title,
          placeholder: widget.placeholder,
          isFocused: isFocused,
          isEmpty: inputWidget == null,
          errorText: errorText.value,
          suffixIcon: FontIcon.caretRight.fontIcon(size: SizeVariant.xs, color: context.colors.inactiveText),
          enabled: enabled.value,
          child: Materials.toInputChild(context, isFocused: isFocused, placeholder: widget.placeholder, child: inputWidget)
      );

      final onTap = enabled.value ? () { // NB! also fires on Enter key
        requestFocus();
        CallUtils.defer(openModal);
      } : null;

      return UniversalInkWell(
          hoverColor: Colors.transparent,
          focusNode: _widgetFocusNode,
          canRequestFocus: enabled.value,
          onFocusChange: (isFocused) {
            this.isFocused.value = isFocused;
          },
          onTap: onTap,
          child: decorator
      );

    });

    return FormField<I>(
        validator: (_) => errorText.value = widget.validator?.call(widget.controller.value),
        builder: (_) => input,
        enabled: enabled.value
    );
  }

}