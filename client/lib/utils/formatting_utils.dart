import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

// FormattingUtils є абстрактним класом, який містить утиліти для форматування тексту, роботи з числами та обчислення математичних виразів.
abstract class FormattingUtils {

  // _f2 - об'єкт NumberFormat для форматування чисел з двома десятковими знаками.
  static final _f2 = NumberFormat("0.00", "en_US"); // TODO find better name

  // formatF2 - статичний метод для форматування числа з двома десятковими знаками.
  static String formatF2(dynamic value) {
    return _f2.format(value);
  }

  // inputNumberAllowedChars - регулярний вираз для визначення допустимих символів у введенні числа.
  static final inputNumberAllowedChars = RegExp(r'[0-9\s,.*/%()^+-]*');

  // inputNumberFormatterAllow - об'єкт FilteringTextInputFormatter для фільтрації допустимих символів у введенні числа.
  static final inputNumberFormatterAllow = FilteringTextInputFormatter.allow(inputNumberAllowedChars);

  // getNewSelection - статичний метод для отримання нового вибору тексту після редагування.
  static TextSelection getNewSelection(TextEditingValue oldValue, String newText) {
    var difference = newText.length - oldValue.text.length;
    return oldValue.selection.copyWith(baseOffset: oldValue.selection.baseOffset + difference, extentOffset: oldValue.selection.baseOffset + difference);
  }

  // formatDecimalString - статичний метод для форматування десяткового числа в текстовому введенні.
  static TextEditingValue formatDecimalString(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if(text.isNotEmpty) {
      if("+-*/".split("").where((e) => text.substring(1).contains(e)).isEmpty) {
        if(!text.contains(".")) {
          if(text.split(",").length == 2) {
            text = text.replaceAll(",", ".");
          }
        }
        text = text.replaceAll(",", "");

        var numArr = text.split(".");

        if(numArr.length > 2) {
          text = text.replaceAll(".", "");
        }
        newValue = newValue.copyWith(text: text, selection: getNewSelection(newValue, text));
      }
    }
    return newValue;

  }

  // _parser - об'єкт Parser для обробки математичних виразів.
  static final Parser _parser = Parser();

  // _parserContext - об'єкт ContextModel для зберігання змінних та функцій під час обчислення математичних виразів.
  static final ContextModel _parserContext = ContextModel();

  // calculateString - статичний метод для обчислення значення математичного виразу, представленого у вигляді рядка.
  static (String, bool) calculateString(String value) {
    try {
      Expression exp = _parser.parse(value);
      var newValue = exp.evaluate(EvaluationType.REAL, _parserContext).toString();
      return (newValue, true);
    } catch(e) {
      return (value, false);
    }
  }

}
