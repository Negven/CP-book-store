
import 'dart:math' as math;

import 'package:client/classes/sizes.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/duration_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_opacity.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'universal_date_picker_config.dart';

export 'universal_date_picker_config.dart';

part '_calendar_view.dart';
part '_date_picker_mode_toggle_button.dart';
part '_day_picker.dart';
part '_focus_date.dart';
part '_year_picker.dart';


const Duration _monthScrollDuration = DurationUtils.slow;

double get _dayPickerRowHeight => sizes.s3R;

const int _maxDayPickerRowCount = 6 + 1; // 6 - a 31 day month that starts on Saturday, 1 - week day-of-week header
double get _maxDayPickerHeight => _dayPickerRowHeight * _maxDayPickerRowCount;

double get _yearPickerRowHeight => _maxDayPickerHeight / 5;

final _headerButtonTemplate = UniversalTemplate(
    type: SurfaceType.text,
    theme: ColorTheme.text,
    paddingType: PaddingType.hh
);

// Should be fully integrated into universal ecosystem at some point
class UniversalDatePicker extends StatefulWidget {

  late final UniversalDatePickerConfig config;
  final List<DateTime?> value;
  final Function(BuildContext, List<DateTime?>)? onValueChanged;
  final DateTime? displayedMonthDate;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  UniversalDatePicker({
    required this.value,
    DatePickerType calendarType = DatePickerType.single,
    required DateTime? firstDate,
    required DateTime? lastDate,
    this.onValueChanged,
    this.displayedMonthDate,
    this.onDisplayedMonthChanged,
    super.key,
  }) :
      config = UniversalDatePickerConfig(calendarType: calendarType, firstDate: firstDate, lastDate: lastDate) {

    const valid = true;
    const invalid = false;

    if (config.calendarType == DatePickerType.single) {
      assert(value.length < 2,
          'Error: single date picker only allows maximum one initial date');
    }

    if (config.calendarType == DatePickerType.range &&
        value.length > 1) {

      final isRangePickerValueValid = value[0] == null
          ? (value[1] != null ? invalid : valid)
          : (value[1] != null
              ? (value[1]!.isBefore(value[0]!) ? invalid : valid)
              : valid);

      assert(
        isRangePickerValueValid,
        'Error: range date picker must has start date set before setting end date, and start date must before end date.',
      );
    }
  }


  @override
  State<UniversalDatePicker> createState() => _UniversalDatePickerState();
}

class _UniversalDatePickerState extends State<UniversalDatePicker> {
  bool _announcedInitialDate = false;
  late List<DateTime?> _selectedDates;
  late DatePickerMode _mode;
  late DateTime _currentDisplayedMonthDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    final initialDate = widget.displayedMonthDate ??
        (widget.value.isNotEmpty && widget.value[0] != null
            ? DateTime(widget.value[0]!.year, widget.value[0]!.month)
            : DateUtils.dateOnly(DateTime.now()));
    _mode = config.calendarViewMode;
    _currentDisplayedMonthDate = DateTime(initialDate.year, initialDate.month);
    _selectedDates = widget.value.toList();
  }

  @override
  void didUpdateWidget(UniversalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.calendarViewMode != oldWidget.config.calendarViewMode) {
      _mode = widget.config.calendarViewMode;
    }

    if (widget.displayedMonthDate != null) {
      _currentDisplayedMonthDate = DateTime(
        widget.displayedMonthDate!.year,
        widget.displayedMonthDate!.month,
      );
    }

    _selectedDates = widget.value.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate && _selectedDates.isNotEmpty) {
      _announcedInitialDate = true;
      for (final date in _selectedDates) {
        if (date != null) {
          SemanticsService.announce(
            _localizations.formatFullDate(date),
            _textDirection,
          );
        }
      }
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_selectedDates.isNotEmpty) {
        for (final date in _selectedDates) {
          if (date != null) {
            SemanticsService.announce(
              _mode == DatePickerMode.day
                  ? _localizations.formatMonthYear(date)
                  : _localizations.formatYear(date),
              _textDirection,
            );
          }
        }
      }
    });
  }

  void _handleMonthChanged(DateTime date, {bool fromYearPicker = false}) {
    setState(() {
      final currentDisplayedMonthDate = DateTime(
        _currentDisplayedMonthDate.year,
        _currentDisplayedMonthDate.month,
      );
      var newDisplayedMonthDate = currentDisplayedMonthDate;

      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        newDisplayedMonthDate = DateTime(date.year, date.month);
      }

      if (fromYearPicker) {
        final selectedDatesInThisYear = _selectedDates
            .where((d) => d?.year == date.year)
            .toList()
          ..sort((d1, d2) => d1!.compareTo(d2!));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(date.year, selectedDatesInThisYear[0]!.month);
        }
      }

      if (currentDisplayedMonthDate.year != newDisplayedMonthDate.year ||
          currentDisplayedMonthDate.month != newDisplayedMonthDate.month) {
        _currentDisplayedMonthDate = DateTime(
          newDisplayedMonthDate.year,
          newDisplayedMonthDate.month,
        );
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    if (value.isBefore(widget.config.firstDate)) {
      value = widget.config.firstDate;
    } else if (value.isAfter(widget.config.lastDate)) {
      value = widget.config.lastDate;
    }

    setState(() {
      _mode = DatePickerMode.day;
      _handleMonthChanged(value, fromYearPicker: true);
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      var selectedDates = [..._selectedDates];
      selectedDates.removeWhere((d) => d == null);

      if (widget.config.calendarType == DatePickerType.single) {
        selectedDates = [value];
      } else if (widget.config.calendarType == DatePickerType.multi) {
        final index =
            selectedDates.indexWhere((d) => DateUtils.isSameDay(d, value));
        if (index != -1) {
          selectedDates.removeAt(index);
        } else {
          selectedDates.add(value);
        }
      } else if (widget.config.calendarType == DatePickerType.range) {
        if (selectedDates.isEmpty) {
          selectedDates.add(value);
        } else {
          final isRangeSet =
              selectedDates.length > 1 && selectedDates[1] != null;
          final isSelectedDayBeforeStartDate =
              value.isBefore(selectedDates[0]!);

          if (isRangeSet || isSelectedDayBeforeStartDate) {
            selectedDates = [value, null];
          } else {
            selectedDates = [selectedDates[0], value];
          }
        }
      }

      selectedDates
        ..removeWhere((d) => d == null)
        ..sort((d1, d2) => d1!.compareTo(d2!));

      final isValueDifferent =
          widget.config.calendarType != DatePickerType.single ||
              !DateUtils.isSameDay(selectedDates[0],
                  _selectedDates.isNotEmpty ? _selectedDates[0] : null);
      if (isValueDifferent) {
        _selectedDates = [...selectedDates];
        widget.onValueChanged?.call(context, _selectedDates);
      }
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePickerMode.day:
        return _CalendarView(
          config: widget.config,
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          selectedDates: _selectedDates,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
        );
      case DatePickerMode.year:
        return _YearPicker(
          config: widget.config,
          key: _yearPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          selectedDates: _selectedDates,
          onChanged: _handleYearChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));

    final currentDate = _currentDisplayedMonthDate;

    final bool isDay = _mode == DatePickerMode.day;

    final header  = Row(
      children: <Widget>[
        isDay ? Expanded(child:
          UniversalButton(
              template: _headerButtonTemplate,
              icon: FontIcon.arrowLeft,
              onPressed: widget.config.isDisplayingFirstMonth(currentDate) ? null : () => (_monthPickerKey.currentState as _CalendarViewState).handlePreviousMonth(),
            )
          ) : const Spacer(),
        Expanded(
          flex: DateTime.daysPerWeek - 2,
          child: _DatePickerModeToggleButton(
            config: widget.config,
            mode: _mode,
            title: widget.config.modePickerTextHandler
                ?.call(monthDate: _currentDisplayedMonthDate) ??
                _localizations.formatMonthYear(_currentDisplayedMonthDate),
            onTitlePressed: () {
              _handleModeChanged(isDay ? DatePickerMode.year : DatePickerMode.day);
            },
        ),
        ),
        isDay ? Expanded(child:
          UniversalButton(
            template: _headerButtonTemplate,
            icon: FontIcon.arrowRight,
            onPressed: widget.config.isDisplayingLastMonth(currentDate) ? null : () => (_monthPickerKey.currentState as _CalendarViewState).handleNextMonth(),
          )
        ) : const Spacer(),
      ],
    );

    final picker = Stack(
      children: <Widget>[
        SizedBox(
          height: _maxDayPickerHeight,
          child: _buildPicker(),
        ),
      ],
    );

    return Column(children: [
      header.withOpacity(O.unfocusedHeader),
      // const Divider(),
      picker
    ]);
  }
}
