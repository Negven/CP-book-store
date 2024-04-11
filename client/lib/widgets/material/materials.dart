import 'package:client/classes/sizes.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/master_texts.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/material/loading_indicator.dart';
import 'package:flutter/material.dart';

// Materials - абстрактний клас, що містить методи для створення матеріальних віджетів.
abstract class Materials {

  // textFormField - метод для створення текстового поля для форми.
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

  // inputDecorator - метод для створення декоратора для введення.
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

  // toEnabled - метод для перевірки наявності віджета та його активації.
  static Widget? toEnabled(bool enable, Widget? child) {
    return child != null && !enable ? Opacity(opacity: 0.8, child: child) : child;
  }

  // toSmallIcon - метод для зменшення розміру іконки.
  static Widget toSmallIcon(Widget small) {
    // From docs: prefixIcon, suffixIcon can't be smaller than 48px, so adjusting this
    return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 48, maxWidth: 48), child: Center(child: small));
  }

  // inputLoading - метод для створення декоратора з індикатором завантаження.
  static InputDecorator inputLoading(BuildContext context, { required String title }) {
    return inputDecorator(context, title: title, child: toInputPlaceholder(context, '_loading'.T)!, enabled: false, suffixIcon: toSmallIcon(const LoadingIndicator.circular(size: SizeVariant.xs)));
  }

  // toInputChild - метод для встановлення вмісту введення.
  static Widget toInputChild(BuildContext context, { bool isFocused = false, String? placeholder, Widget? child }) {
    final isEmpty = child == null;
    // NB! "" must be to prevent jumping
    return isEmpty && isFocused ? toInputPlaceholderR(context, placeholder ?? "") : (isEmpty ? toInputTextR(context, "") : child);
  }

  // toInputText - метод для відображення тексту введення.
  static Text? toInputText(BuildContext context, String? text) {
    return text != null ? Text(text, style: context.texts.inputText) : null;
  }

  // toInputTextR - метод для відображення тексту введення.
  static Text toInputTextR(BuildContext context, String text) {
    return toInputText(context, text)!;
  }

  // toInputPlaceholder - метод для відображення тексту-заповнювача введення.
  static Text? toInputPlaceholder(BuildContext context, String? text) {
    return text != null ? Text(text, style: context.texts.inputText) : null;
  }

  // toInputPlaceholderR - метод для відображення тексту-заповнювача введення.
  static Text toInputPlaceholderR(BuildContext context, String text) {
    return toInputPlaceholder(context, text)!;
  }
}
