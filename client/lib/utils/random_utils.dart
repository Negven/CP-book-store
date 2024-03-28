

import 'dart:math';

abstract class RandomUtils {

  static final Random _random = Random();

  static int nextLong() {
    final high = _random.nextInt(1 << 32);
    final low = _random.nextInt(0xFFFFFFFF);
    return (high << 32) | low;
  }

}
