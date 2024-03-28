

import 'package:client/enum/language_code.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

// NB! Mainly to force strict type checking

abstract class ADate<UD, CD> {
  UD toUtc();
  CD toClient();
  String format();
}

final isoDateFormat = DateFormat("yyyy-MM-dd");
final isoDateTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); // ISO_8601_PATTERN

class UtcDateTime extends DateTime implements ADate<UtcDateTime, ClientDateTime> {

  UtcDateTime.from(DateTime dateTime) : super.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch, isUtc: true);
  UtcDateTime.parse(String value) : this.from(isoDateTimeFormat.parse(value, true));

  UtcDateTime._now() : super.now();

  @override
  UtcDateTime toUtc() => this;

  @override
  ClientDateTime toClient() => ClientDateTime.from(this);

  @override
  String format() => isoDateTimeFormat.format(this);

  static UtcDateTime get now => UtcDateTime.from(UtcDateTime._now());

  static UtcDateTime? tryParse(dynamic value) {
    if (value == null) return null;
    if (value is String) return UtcDateTime.parse(value);
    throw "Invalid value, expected String, but got $value";
  }
}


class ClientDateTime extends DateTime implements ADate<UtcDateTime, ClientDateTime> {

  ClientDateTime.from(DateTime dateTime) : super.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch, isUtc: false);
  ClientDateTime(super.year, [super.month, super.day, super.hour, super.minute, super.second]);
  ClientDateTime._now() : super.now();

  @override
  UtcDateTime toUtc() => UtcDateTime.from(this);

  @override
  ClientDateTime toClient() => this;

  @override
  String format() => DateTimeUtils.clientDateTimeFormat.format(this);

  static ClientDateTime get now => ClientDateTime._now();
}

class UtcDate extends DateTime implements ADate<UtcDate, ClientDate> {

  UtcDate(super.year, [super.month, super.day]) : super.utc();
  UtcDate.from(DateTime dateTime) : this(dateTime.year, dateTime.month, dateTime.day);
  UtcDate.parse(String value) : this.from(isoDateFormat.parse(value, true));

  @override
  UtcDate toUtc() => this;

  @override
  ClientDate toClient() => ClientDate(year, month, day);

  @override
  String format() => isoDateFormat.format(this);

  static UtcDate get now => UtcDate.from(UtcDateTime.now);

  static UtcDate? tryParse(dynamic value) {
    if (value == null) return null;
    if (value is String) return UtcDate.parse(value);
    throw "Invalid value, expected String, but got $value";
  }

}


class ClientDate extends DateTime implements ADate<UtcDate, ClientDate> {

  ClientDate._now() : super.now();
  ClientDate(super.year, [super.month, super.day]);
  ClientDate.from(DateTime dateTime) : this(dateTime.year, dateTime.month, dateTime.day);

  @override
  UtcDate toUtc() => UtcDate(year, month, day);

  @override
  ClientDate toClient() => this;

  @override
  String format() => DateTimeUtils.clientDateFormat.format(this);

  static ClientDate get now => ClientDate._now();

}


abstract class DateTimeUtils {

  static DateFormat? _clientDateFormat;
  static DateFormat get clientDateFormat => _clientDateFormat!;

  static DateFormat? _clientDateTimeFormat;
  static DateFormat get clientDateTimeFormat => _clientDateTimeFormat!;

  static void setLocale(LanguageCode languageCode) {

    Intl.defaultLocale = languageCode.name;

    initializeDateFormattingCustom(
        locale: languageCode.name,
        symbols: dateTimeSymbolMap[languageCode],
        patterns: dateTimePatternMap[languageCode]
    );

    _clientDateFormat = DateFormat.yMd();
    _clientDateTimeFormat = DateFormat.yMd().add_Hms();
  }

  static const common = {
    'E': 'ccc', // ABBR_WEEKDAY
    'EEEE': 'cccc', // WEEKDAY
    'LLL': 'LLL', // ABBR_STANDALONE_MONTH
    'LLLL': 'LLLL', // STANDALONE_MONTH
    'MEd': 'EEE dd.MM', // NUM_MONTH_WEEKDAY_DAY
    'MMM': 'LLL', // ABBR_MONTH
    'MMMM': 'LLLL', // MONTH
    'QQQ': 'QQQ', // ABBR_QUARTER
    'QQQQ': 'QQQQ', // QUARTER
    'y': 'y', // YEAR
    'yM': 'MM.y', // YEAR_NUM_MONTH
    'yMd': 'dd.MM.y', // YEAR_NUM_MONTH_DAY
    'yMMM': 'MMM y', // YEAR_ABBR_MONTH
    'yMMMM': 'MMMM y', // YEAR_MONTH
    'yQQQ': 'QQQ y', // YEAR_ABBR_QUARTER
    'yQQQQ': 'QQQQ y', // YEAR_QUARTER
    'H': 'HH', // HOUR24
    'Hm': 'HH:mm', // HOUR24_MINUTE
    'Hms': 'HH:mm:ss', // HOUR24_MINUTE_SECOND
    'j': 'HH', // HOUR
    'jm': 'HH:mm', // HOUR_MINUTE
    'jms': 'HH:mm:ss', // HOUR_MINUTE_SECOND
    'jmv': 'HH:mm v', // HOUR_MINUTE_GENERIC_TZ
    'jmz': 'HH:mm z', // HOUR_MINUTETZ
    'jz': 'HH z', // HOURGENERIC_TZ
    'm': 'm', // MINUTE
    'ms': 'mm:ss', // MINUTE_SECOND
    's': 's', // SECOND
    'v': 'v', // ABBR_GENERIC_TZ
    'z': 'z', // ABBR_SPECIFIC_TZ
    'zzzz': 'zzzz', // SPECIFIC_TZ
    'ZZZZ': 'ZZZZ' // ABBR_UTC_TZ
  };

  static const nb = {
    'd': 'd.', // DAY
    'M': 'L.', // NUM_MONTH
    'Md': 'dd.MM.', // NUM_MONTH_DAY
    'MMMd': 'd. MMM', // ABBR_MONTH_DAY
    'MMMEd': 'EEE d. MMM', // ABBR_MONTH_WEEKDAY_DAY
    'MMMMEEEEd': 'EEEE d. MMMM', // MONTH_WEEKDAY_DAY
    'yMEd': 'EEE dd.MM.y', // YEAR_NUM_MONTH_WEEKDAY_DAY
    'yMMMd': 'd. MMM y', // YEAR_ABBR_MONTH_DAY
    'yMMMEd': 'EEE d. MMM y', // YEAR_ABBR_MONTH_WEEKDAY_DAY
    'yMMMMd': 'd. MMMM y', // YEAR_MONTH_DAY
    'yMMMMEEEEd': 'EEEE d. MMMM y', // YEAR_MONTH_WEEKDAY_DAY
  };

  static const en = {
    'd': 'd', // DAY
    'M': 'L', // NUM_MONTH
    'Md': 'dd.MM', // NUM_MONTH_DAY
    'MMMd': 'd MMM', // ABBR_MONTH_DAY
    'MMMEd': 'EEE d MMM', // ABBR_MONTH_WEEKDAY_DAY
    'MMMMd': 'd MMMM', // MONTH_DAY
    'MMMMEEEEd': 'EEEE d MMMM', // MONTH_WEEKDAY_DAY
    'yMEd': 'EEE dd.MM.y', // YEAR_NUM_MONTH_WEEKDAY_DAY
    'yMMMd': 'd MMM y', // YEAR_ABBR_MONTH_DAY
    'yMMMEd': 'EEE d MMM y', // YEAR_ABBR_MONTH_WEEKDAY_DAY
    'yMMMMd': 'd MMMM y', // YEAR_MONTH_DAY
    'yMMMMEEEEd': 'EEEE d MMMM y', // YEAR_MONTH_WEEKDAY_DAY
  };

  static Map<LanguageCode,DateSymbols> get dateTimeSymbolMap => {
    LanguageCode.en: DateSymbols(
      NAME: LanguageCode.en.name,
      ERAS: const ['BC', 'AD'],
      ERANAMES: const ['Before Christ', 'Anno Domini'],
      NARROWMONTHS: const ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      STANDALONENARROWMONTHS: const ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      MONTHS: const ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      STANDALONEMONTHS: const ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      SHORTMONTHS: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'],
      STANDALONESHORTMONTHS: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'],
      WEEKDAYS: const ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      STANDALONEWEEKDAYS: const ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      SHORTWEEKDAYS: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      STANDALONESHORTWEEKDAYS: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      NARROWWEEKDAYS: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      STANDALONENARROWWEEKDAYS: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      SHORTQUARTERS: const ['Q1', 'Q2', 'Q3', 'Q4'],
      QUARTERS: const ['1st quarter', '2nd quarter', '3rd quarter', '4th quarter'],
      AMPMS: const ['am', 'pm'],
      FIRSTDAYOFWEEK: 0,
      WEEKENDRANGE: const [5, 6],
      FIRSTWEEKCUTOFFDAY: 3,
      DATEFORMATS: const [],
      TIMEFORMATS: const [],
      DATETIMEFORMATS: const [],
    ),
    LanguageCode.nb: DateSymbols(
      NAME: LanguageCode.nb.name,
      ERAS: const ['f.Kr.', 'e.Kr.'],
      ERANAMES: const ['før Kristus', 'etter Kristus'],
      NARROWMONTHS: const ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      STANDALONENARROWMONTHS: const ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      MONTHS: const ['januar', 'februar', 'mars', 'april', 'mai', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'desember'],
      STANDALONEMONTHS: const ['januar', 'februar', 'mars', 'april', 'mai', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'desember'],
      SHORTMONTHS: const ['jan.', 'feb.', 'mar.', 'apr.', 'mai', 'jun.', 'jul.', 'aug.', 'sep.', 'okt.', 'nov.', 'des.'],
      STANDALONESHORTMONTHS: const ['jan', 'feb', 'mar', 'apr', 'mai', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'des'],
      WEEKDAYS: const ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
      STANDALONEWEEKDAYS: const ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
      SHORTWEEKDAYS: const ['søn.', 'man.', 'tir.', 'ons.', 'tor.', 'fre.', 'lør.'],
      STANDALONESHORTWEEKDAYS: const ['søn.', 'man.', 'tir.', 'ons.', 'tor.', 'fre.', 'lør.'],
      NARROWWEEKDAYS: const ['S', 'M', 'T', 'O', 'T', 'F', 'L'],
      STANDALONENARROWWEEKDAYS: const ['S', 'M', 'T', 'O', 'T', 'F', 'L'],
      SHORTQUARTERS: const ['K1', 'K2', 'K3', 'K4'],
      QUARTERS: const ['1. kvartal', '2. kvartal', '3. kvartal', '4. kvartal'],
      AMPMS: const ['a.m.', 'p.m.'],
      FIRSTDAYOFWEEK: 0,
      WEEKENDRANGE: const [5, 6],
      FIRSTWEEKCUTOFFDAY: 3,
      DATEFORMATS: const [],
      TIMEFORMATS: const [],
      DATETIMEFORMATS: const [],
    ),
  };

  static Map<LanguageCode,Map<String,String>> get dateTimePatternMap => {
    LanguageCode.en: ConvertUtils.mergeUnique([en, common]),
    LanguageCode.nb: ConvertUtils.mergeUnique([nb, common])
  };
}