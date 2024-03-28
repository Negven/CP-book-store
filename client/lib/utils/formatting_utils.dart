

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

abstract class FormattingUtils {

  static final _f2 = NumberFormat("0.00", "en_US"); // TODO find better name

  static String formatF2(dynamic value) {
    return _f2.format(value);
  }
  static final inputNumberAllowedChars = RegExp(r'[0-9\s,.*/%()^+-]*');
  static final inputNumberFormatterAllow = FilteringTextInputFormatter.allow(inputNumberAllowedChars);

  static TextSelection getNewSelection(TextEditingValue oldValue, String newText) {
    var difference = newText.length - oldValue.text.length;
    return oldValue.selection.copyWith(baseOffset: oldValue.selection.baseOffset + difference, extentOffset: oldValue.selection.baseOffset + difference);
  }

  // 100,000  -> 100.000
  // ["1+1", "1+1"],
  // ["+100,00,00", "+1000000"],
  // 10,00,00 -> 100000 ( >=  0)
  // 10,00.00 -> 1000.00
  // 10.00.00 -> 100000 ( >= 0)
  // ,10 -> .10
  // 10, -> 10.
  // .10 -> .10 (in tests)
  // 10. -> 10. (in tests)
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
        // newValue = newValue.copyWith(text: text); // for test
        newValue = newValue.copyWith(text: text, selection: getNewSelection(newValue, text));
      }
    }
    return newValue;

  }

  static final Parser _parser = Parser();
  static final ContextModel _parserContext = ContextModel();

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