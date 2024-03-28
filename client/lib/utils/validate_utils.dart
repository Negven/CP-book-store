

import 'package:client/service/translations_service.dart';
import 'package:client/utils/encryption_utils.dart';
import 'package:client/utils/string_utils.dart';
import 'package:flutter/material.dart';

import '../widgets/universal/universal_item.dart';



abstract class ValidateUtils {

  static bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  static String? required<T>(T? value) {
    return value == null ? "validation_fieldIsRequired".T : null;
  }

  static String? requiredUniversal<I extends UniversalItem>(I? item) {

    if (item != null && item.value is String) {
      return requiredString(item.value as String);
    }

    return item == null ? "validation_fieldIsRequired".T : null;
  }

  static String? requiredString(String? value) {
    return StringUtils.isEmpty(value) ? "validation_fieldIsRequired".T : null;
  }

  static String? requiredEmail(String? value) {
    if(requiredString(value) != null) return requiredString(value);
    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value!)) {
      return 'validation_wrongMailFormat'.T;
    }
    return null;
  }

  static String? requiredPassword(String? value) {
    if(requiredString(value) != null) return requiredString(value);
    if (value!.length < 8) {
      return 'validation_shortPassword'.T;
    }
    return null;
  }

  static String? walletName(String? value) {

    String? v = requiredString(value);
    if (v != null) {
      return v;
    }

    if (StringUtils.isEmpty(StringUtils.toWalletFileName(value!))) {
      return "validation_fieldValueInvalid".T;
    }

    return null;
  }

  static String? masterKey(String? value) {

    String? v = requiredString(value);
    if (v != null) {
      return v;
    }

    if (!EncryptionUtils.validateMasterKey64(value)) {
       return "validation_fieldValueInvalid".T;
    }

    return null;
  }

  static String? validateEmojiBasedIconR(String? icon) {
    return _validateEmojiBasedIcon(icon, true);
  }

  static String? validateEmojiBasedIcon(String? icon) {
    return _validateEmojiBasedIcon(icon, false);
  }

  static String? _validateEmojiBasedIcon(String? icon, bool required) {

    if (StringUtils.isEmpty(icon)) return required ? "validation_fieldIsRequired".T : null;

    if (icon!.characters.length != 1) {
      return "validation_fieldValueInvalid".T;
    }

    return null;
  }
}