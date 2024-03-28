import 'package:flutter/material.dart';

enum DatePickerType { single, multi, range }

typedef DatePickerDayTextStylePredicate = TextStyle? Function({
  required DateTime date,
});

typedef DatePickerDayBuilder = Widget? Function({
  required DateTime date,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isToday,
});

typedef DatePickerYearBuilder = Widget? Function({
  required int year,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentYear,
});

typedef CalendarModePickerTextHandler = String? Function({
  required DateTime monthDate,
});

class UniversalDatePickerConfig {

  UniversalDatePickerConfig({
    DatePickerType? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    this.firstDayOfWeek,
    this.selectableDayPredicate,
    this.dayTextStylePredicate,
    this.dayBuilder,
    this.yearBuilder,
    this.disableModePicker,
    this.modePickerTextHandler,
  })  : calendarType = calendarType ?? DatePickerType.single,
        firstDate = DateUtils.dateOnly(firstDate ?? DateTime(1970)),
        lastDate = DateUtils.dateOnly(lastDate ?? DateTime(DateTime.now().year + 50)),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? DatePickerMode.day;

  final DatePickerType calendarType;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final DatePickerMode calendarViewMode;

  /// Index of the first day of week, where 0 points to Sunday, and 6 points to Saturday.
  final int? firstDayOfWeek;

  final SelectableDayPredicate? selectableDayPredicate;

  final DatePickerDayTextStylePredicate? dayTextStylePredicate;

  final DatePickerDayBuilder? dayBuilder;

  final DatePickerYearBuilder? yearBuilder;

  final bool? disableModePicker;

  final CalendarModePickerTextHandler? modePickerTextHandler;

  /// True if the earliest allowable month is displayed.
  bool isDisplayingFirstMonth(DateTime currentMonth) {
    return !currentMonth.isAfter(
      DateTime(firstDate.year, firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool isDisplayingLastMonth(DateTime currentMonth) {
    return !currentMonth.isBefore(
      DateTime(lastDate.year, lastDate.month),
    );
  }

  UniversalDatePickerConfig copyWith({
    DatePickerType? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    int? firstDayOfWeek,
    SelectableDayPredicate? selectableDayPredicate,
    DatePickerDayTextStylePredicate? dayTextStylePredicate,
    DatePickerDayBuilder? dayBuilder,
    DatePickerYearBuilder? yearBuilder,
    bool? disableModePicker,
    CalendarModePickerTextHandler? modePickerTextHandler,
  }) {
    return UniversalDatePickerConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      selectableDayPredicate: selectableDayPredicate ?? this.selectableDayPredicate,
      dayTextStylePredicate: dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      yearBuilder: yearBuilder ?? this.yearBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      modePickerTextHandler: modePickerTextHandler ?? this.modePickerTextHandler,
    );
  }
}
