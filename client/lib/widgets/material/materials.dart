
import 'package:client/classes/sizes.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/master_texts.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/material/loading_indicator.dart';
import 'package:flutter/material.dart';


abstract class Materials {

  static TextFormField textFormField(BuildContext context, {
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    bool readOnly = false,
    bool? enabled,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
    bool withEmoji = false,
    int? minLines,
    int maxLines = 1,
    void Function()? onTap,
    TextAlign textAlign = TextAlign.start,
    TextStyle? style,
    bool obscureText = false,
    ValueChanged<String>? onFieldSubmitted}) {

    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      obscureText: obscureText,
      style: MasterTexts.withEmoji(style ?? context.texts.inputText),
      readOnly: readOnly,
      enabled: enabled,
      validator: validator,
      focusNode: focusNode,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: textAlign,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText
      )
    );
  }

  static InputDecorator inputDecorator(BuildContext context, { required String title,
    String? placeholder,
    bool isFocused = false,
    bool isEmpty = false,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    enabled = true,
    required Widget child }) {
    return InputDecorator(
        baseStyle: context.texts.inputText,
        isFocused: isFocused,
        isEmpty: isEmpty,
        decoration: InputDecoration(
            labelText: isEmpty && !isFocused ? (placeholder ?? title) : title,
            errorText: errorText,
            prefixIcon: toEnabled(enabled, prefixIcon),
            suffixIcon: toEnabled(enabled, suffixIcon),
            enabled: enabled
        ),
        child: toEnabled(enabled, child)
    );
  }

  // static InkWell inkWell(BuildContext context, { Color? hoverColor, Color? highlightColor, FocusNode? focusNode, bool canRequestFocus = true, void Function(bool)? onFocusChange, VoidCallback? onTap, Widget? child }) {
  //   return InkWell(
  //
  //       hoverColor: hoverColor,
  //       focusColor: Colors.transparent,
  //       highlightColor: highlightColor ?? context.colors.backgroundL1,
  //       splashColor: context.colors.secondary,
  //       borderRadius: context.styles.borderRadiusSm,
  //
  //       focusNode: focusNode,
  //       canRequestFocus: canRequestFocus,
  //       onFocusChange: onFocusChange,
  //       onTap: onTap,
  //       child: child
  //   );
  // }

  static Widget? toEnabled(bool enable, Widget? child) {
    return child != null && !enable ? Opacity(opacity: 0.8, child: child) : child;
  }

  static Widget toSmallIcon(Widget small) {
    // From docs: prefixIcon, suffixIcon can't be smaller than 48px, so adjusting this
    return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 48, maxWidth: 48), child: Center(child: small));
  }

  static InputDecorator inputLoading(BuildContext context, { required String title }) {
    return inputDecorator(context, title: title, child: toInputPlaceholder(context, '_loading'.T)!, enabled: false, suffixIcon: toSmallIcon(const LoadingIndicator.circular(size: SizeVariant.xs)));
  }

  static Widget toInputChild(BuildContext context, { bool isFocused = false, String? placeholder, Widget? child }) {
    final isEmpty = child == null;
    // NB! "" must be to prevent jumping
    return isEmpty && isFocused ? toInputPlaceholderR(context, placeholder ?? "") : (isEmpty ? toInputTextR(context, "") : child);
  }


  static Text? toInputText(BuildContext context, String? text) {
    return text != null ? Text(text, style: context.texts.inputText) : null;
  }

  static Text toInputTextR(BuildContext context, String text) {
    return toInputText(context, text)!;
  }

  static Text? toInputPlaceholder(BuildContext context, String? text) {
    return text != null ? Text(text, style: context.texts.inputText) : null;
  }
  static Text toInputPlaceholderR(BuildContext context, String text) {
    return toInputPlaceholder(context, text)!;
  }



}