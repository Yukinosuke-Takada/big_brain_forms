part of '../../big_brain_forms.dart';

/// A complimentary widget. A value field where you have to change the value with a stepper.
class ValueSteppers extends StatefulWidget {
  /// Creates a value field where you have to change the value with a stepper.
  const ValueSteppers({
    required this.labelText,
    super.key,
    this.controller,
    this.initialValue = 0,
    this.minValue,
    this.maxValue,
    this.steps = 1,
    this.readOnly = false,
    this.onValueChanged,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.incrementIcon = const Icon(Icons.add),
    this.decrementIcon = const Icon(Icons.remove),
    this.labelBottomPadding = 8.0,
    this.bottomPadding = 18.0,
  });

  /// The controller for the value stepper. The passed controller with be initialized with the given parameters:
  /// [initialValue], [steps]. If null, a local controller will be created.
  final ValueSteppersController? controller;
  /// The initial value of the stepper.
  final int initialValue;
  /// The minimum value that the stepper can be set to.
  final int? minValue;
  /// The maximum value that the stepper can be set to.
  final int? maxValue;
  /// The number of steps to increment or decrement the value.
  final int steps;
  /// Whether the stepper is read only. If true, the stepper cannot be changed and greyed out.
  final bool readOnly;
  /// Callback function for when the value of the stepper changes.
  final void Function(int value)? onValueChanged;
  /// The text to display above the stepper.
  final String labelText;
  /// The font size of the label and value.
  final double? textFontSize;
  /// The text style of the label.
  final TextStyle? labelTextStyle;
  /// The text style of the value.
  final TextStyle? valueTextStyle;
  /// The icon for the increment stepper button.
  final Icon incrementIcon;
  /// The icon for the decrement stepper button.
  final Icon decrementIcon;
  /// The padding between the label and the stepper.
  final double labelBottomPadding;
  /// The padding at the bottom of this widget.
  final double bottomPadding;


  @override
  State<ValueSteppers> createState() => _ValueSteppersState();
}

class _ValueSteppersState extends State<ValueSteppers> {
  /// The local controller for the stepper. Only used if widget.controller is null.
  ValueSteppersController? _localController;
  // Returns the effective controller.
  ValueSteppersController get _effectiveController => widget.controller ?? _localController!;

  /// The current value of the stepper.
  late int _value;

  // Checks if the stepper can be incremented.
  bool _canIncrement() {
    if (widget.readOnly) {
      return false;
    }
    if (widget.maxValue != null && _value + widget.steps > widget.maxValue!) {
      return false;
    }
    return true;
  }

  // Checks if the stepper can be decremented.
  bool _canDecrement() {
    if (widget.readOnly) {
      return false;
    }
    if (widget.minValue != null && _value - widget.steps < widget.minValue!) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    // Initialize the value of the stepper.
    _value = widget.initialValue;
    // Initialize the controller.
    if (widget.controller == null) {
      _localController = ValueSteppersController.fromValue(
        initialValue: widget.initialValue,
        steps: widget.steps,
      );
    } else {
      widget.controller!.setInitialValues(
        initialValue: widget.initialValue,
        steps: widget.steps,
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

  /// When the controller value changes, update the value of the stepper and call the callback function.
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
              const Spacer(),
              Text(
                _value.toString(),
                style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize),
              ),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          Row(
            children: [
              const Spacer(),
              IconButton.filledTonal(
                onPressed: _canDecrement() ? () {
                  if (_canDecrement()) _effectiveController.decrement();
                } : null,
                icon: widget.decrementIcon,
              ),
              IconButton.filledTonal(
                onPressed: _canIncrement() ? () {
                  if (_canIncrement()) _effectiveController.increment();
                } : null,
                icon: widget.incrementIcon,
              ),
            ],
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}
