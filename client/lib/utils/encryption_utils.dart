
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:client/utils/convert_utils.dart';
import 'package:flutter/foundation.dart';


class _SeededRandom {

  static _SeededRandom? _instance;
  static _SeededRandom get instance  => _instance!;

  late final Random _platform;
  late final List<int> seed;

  _SeededRandom(List<int> delayedSeed) {
    assert(delayedSeed.length == _Aes.keySize);

    try {
      _platform = Random.secure();
    } on UnsupportedError {
      _platform = Random();
    }

    List<int> seed = [];
    for (int i = 0; i < _Aes.keySize; i++) {
      seed.add(_platform.nextInt(256) ^ delayedSeed[i]);
    }

    this.seed = seed;

  }

  Uint8List nextBytes(int size) {
    final randomized = Uint8List(size);
    for (int i = 0; i < randomized.length; i++) {
      randomized[i] = seed[i % seed.length] ^ _platform.nextInt(256);
    }
    return randomized;
  }


  static Future<List<int>> delayedSeed() async {

    final result = <int>[];

    final bits = <int>[];
    for (var i = 0; i < 64; i++) {

      await Future.delayed(const Duration(milliseconds: 1));

      final n = DateTime.now();
      final ms = n.millisecond;
      final mse = n.millisecondsSinceEpoch;

      bits.add(mse % 2);
      bits.add(mse % 3 == 1 ? 1 : 0);
      bits.add(ms % 2);
      bits.add(ms % 3 == 0 ? 1 : 0);

      if (bits.length == 8) {
        result.add(int.parse(bits.join(''), radix: 2));
        bits.length = 0;
      }
    }

    assert(result.length == _Aes.keySize);
    return result;
  }
}


class AesKey {

  final Uint8List iv;
  final Uint8List key;

  AesKey(this.iv, this.key) {
    assert (iv.length == _Aes.ivSize && key.length == _Aes.keySize);
  }

  String toBase64Url() {
    return EncryptionUtils.base64UrlEncode(ConvertUtils.concat(iv, key));
  }

  bool isSame(AesKey other) => listEquals(iv, other.iv) && listEquals(key, other.key);
}

// NB! Never send MasterKey to back-end as it's secret key
class MasterKey extends AesKey {

  MasterKey._(super.iv, super.key);

  String toAuthKey() => EncryptionUtils.base64UrlEncode(iv);

  String toPrettyString() => ConvertUtils.splitString(toBase64Url(), 16).join("\n");

  static MasterKey fromBase64Url(String b64) {
    var v = EncryptionUtils.base64UrlDecode(EncryptionUtils.cleanBase64UrlString(b64)); // NB! clean in case of input trailing symbols
    return MasterKey._(v.sublist(0, _Aes.ivSize), v.sublist(_Aes.ivSize, v.length));
  }

  static MasterKey generate() {
    while (true) {
      final masterKey = MasterKey._(EncryptionUtils.aesIv(), EncryptionUtils.aesKey());
      final b64url = masterKey.toBase64Url();
      if (!b64url.contains('-') && !b64url.contains('_')) {
        return masterKey;
      }
    }
  }

  static bool validate(String? value) {

    if (value == null) return false;

    try {
      MasterKey.fromBase64Url(value);
      return true;
    } catch (e, st) {
      debugPrintStack(stackTrace: st, label: "$e");
      return false;
    }
  }

}


class _Aes {

  static const ivSize = 16;
  static const keySize = 32;

  static Uint8List nextIv() {
    return _SeededRandom.instance.nextBytes(ivSize);
  }

  static Uint8List nextKey() {
    return _SeededRandom.instance.nextBytes(keySize);
  }

  static Uint8List nextSecret() {
    return ConvertUtils.concat(nextKey(), nextIv());
  }

}


abstract class EncryptionUtils {

  static bool validateMasterKey64(String? masterKey) =>
    MasterKey.validate(masterKey);


  static Future<void> secureRandomInit() async {
    var seed = await _SeededRandom.delayedSeed();
    _SeededRandom._instance = _SeededRandom(seed);
  }

  static Uint8List aesIv() {
    return _Aes.nextIv();
  }

  static Uint8List aesKey() {
    return _Aes.nextKey();
  }

  static Uint8List aesSecret() {
    return _Aes.nextSecret();
  }

  static final RegExp _nonBase64UrlRegExp = RegExp('[^A-Za-z0-9-_]');
  static String cleanBase64UrlString(String value) => value.replaceAll(_nonBase64UrlRegExp, '');

  static String base64UrlEncode(List<int> value) {
    var encoded = base64Url.encode(value);
    return encoded.endsWith('=') ? cleanBase64UrlString(encoded) : encoded;
  }

  static Uint8List base64UrlDecode(String value) => base64Url.decode(base64Url.normalize(value));

  static List<int> utf8Encode(String value) => utf8.encode(value);
  static String utf8Decode(List<int> value) => utf8.decode(value);


}



