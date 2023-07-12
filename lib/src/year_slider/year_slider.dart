part of '../../big_brain_forms.dart';

/// A complimentary widget. A year field where you have to select the year from a slider.
class YearSlider extends StatefulWidget {
  /// Creates a year field where you have to select the year from a slider.
  const YearSlider({
    required this.minYear,
    required this.maxYear,
    required this.labelText,
    super.key,
    this.controller,
    this.initialYear = 0,
    this.readOnly = false,
    this.onValueChanged,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.labelBottomPadding = 18.0,
    this.bottomPadding = 18.0,
  });

  /// The controller for the year slider. The passed controller with be initialized with the given parameters:
  /// [initialYear]. If null, a local controller will be created.
  final YearSliderController? controller;
  /// The initial value of the year slider.
  final int initialYear;
  /// The minimum year that the slider can be set to.
  final int minYear;
  /// The maximum year that the slider can be set to.
  final int maxYear;
  /// Whether the year slider is read only. If true, the slider cannot be changed and greyed out.
  final bool readOnly;
  /// Callback function for when the value of the year slider changes.
  final void Function(Year value)? onValueChanged;
  /// The text to display above the slider.
  final String labelText;
  /// The font size of the label and value.
  final double? textFontSize;
  /// The text style of the label.
  final TextStyle? labelTextStyle;
  /// The text style of the value.
  final TextStyle? valueTextStyle;
  /// The padding between the label and the slider.
  final double labelBottomPadding;
  /// The padding at the bottom of this widget.
  final double bottomPadding;


  @override
  State<YearSlider> createState() => _YearSliderState();
}

class _YearSliderState extends State<YearSlider> {
  /// The local controller for the year slider. Only used if widget.controller is null.
  YearSliderController? _localController;
  // Returns the effective controller.
  YearSliderController get _effectiveController => widget.controller ?? _localController!;

  /// The current value of the year slider.
  late Year _value;

  @override
  void initState() {
    // Initialize the value of the year slider.
    _value = Year(widget.initialYear);
    // Initialize the controller.
    if (widget.controller == null) {
      _localController = YearSliderController.fromValue(
        initialYear: widget.initialYear,
      );
    } else {
      widget.controller!.setInitialValues(
        initialYear: widget.initialYear,
      );
    }
    _effectiveController.addListener(_handleValueChange);
    super.initState();
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleValueChange);
    // Dispose the local controller if it was created.
    _localController?.dispose();
    super.dispose();
  }

  /// When the controller value changes, update the value of the year slider and call the callback function.
  void _handleValueChange() {
    final newValue = _effectiveController.getValue();
    widget.onValueChanged?.call(newValue);
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.labelText,
                style: widget.labelTextStyle ?? TextStyle(fontSize: widget.textFontSize),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _value.withFormat(),
                    style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: _value.year.toDouble(),
              min: widget.minYear.toDouble(),
              max: widget.maxYear.toDouble(),
              onChanged: (value) {
                _effectiveController.onSliderChange(value);
              },
            ),
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}
