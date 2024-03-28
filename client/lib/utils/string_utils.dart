

abstract class StringUtils {

  static bool isNotEmpty(String? s) {
    return s != null && s.isNotEmpty;
  }

  static bool everyNotEmpty(List<String?> args) {
    return args.every(StringUtils.isNotEmpty);
  }

  static bool anyNotEmpty(List<String?> args) {
    return args.any(StringUtils.isNotEmpty);
  }

  static bool isEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }

  static bool everyIsEmpty(List<String?> args) {
    return args.every(StringUtils.isEmpty);
  }

  static bool anyIsEmpty(List<String?> args) {
    return args.any(StringUtils.isEmpty);
  }

  static bool containsIn(String query, [String? string1, String? string2, String? string3]) {
    return contains(query, string1) || contains(query, string2) || contains(query, string3);
  }

  static bool contains(String query, String? string) {
    if (string == null) return false;
    return string.toLowerCase().contains(query);
  }


  static String toSafeString(String input, int? maxLength) {
    if (isEmpty(input)) return "";

    if (maxLength != null) {
      input = input.substring(0, maxLength.clamp(0, input.length));
    }

    return input.replaceAll(RegExp(r'[/"<>;*&?]'), '');
  }

  static String toWalletFileName(String walletName) {
    String safeName = toSafeString(walletName, null);
    return safeName.toLowerCase().replaceAll(RegExp(r'\s'), '_');
  }

}