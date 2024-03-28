
part of 'universal_date_picker.dart';

/// A button that used to toggle the [DatePickerMode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePickerMode] to display either the calendar view or the year list.
class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    required this.mode,
    required this.title,
    required this.onTitlePressed,
    required this.config,
  });

  /// The current display of the calendar picker.
  final DatePickerMode mode;

  /// The text that displays the current month/year being viewed.
  final String title;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  /// The calendar configurations
  final UniversalDatePickerConfig config;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.mode == DatePickerMode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: _monthScrollDuration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerMode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UniversalTextButton(
        template: _headerButtonTemplate,
        text: widget.title,
        alignment: Alignment.center,
        icon: FontIcon.caretDown,
        iconSize: SizeVariant.xs,
        iconPosition: IconPosition.suffix,
        iconWrapper: (icon) => RotationTransition(
          turns: _controller,
          child: icon,
        ),
        onPressed: widget.config.disableModePicker == true
            ? null
            : widget.onTitlePressed,
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
