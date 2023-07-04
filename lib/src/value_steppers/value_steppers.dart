part of '../../big_brain_forms.dart';

class ValueSteppers extends StatefulWidget {
  final ValueSteppersController? controller;
  final int initialValue;
  final int? minValue;
  final int? maxValue;
  final int steps;
  final bool readOnly;
  final void Function(int value)? onValueChanged;
  final String text;
  final double? textFontSize;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final Icon incrementIcon;
  final Icon decrementIcon;
  final double labelBottomPadding;
  final double bottomPadding;

  const ValueSteppers({
    super.key,
    this.controller,
    this.initialValue = 0,
    this.minValue,
    this.maxValue,
    this.steps = 1,
    this.readOnly = false,
    this.onValueChanged,
    required this.text,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.incrementIcon = const Icon(Icons.add),
    this.decrementIcon = const Icon(Icons.remove),
    this.labelBottomPadding = 8.0,
    this.bottomPadding = 18.0,
  });

  @override
  State<ValueSteppers> createState() => _ValueSteppersState();
}

class _ValueSteppersState extends State<ValueSteppers> {
  late ValueSteppersController _controller;
  late int _value;

  void _onValueChanged(int value) {
    setState(() {
      _value = value;
    });
  }

  bool canIncrement() {
    if (widget.readOnly) {
      return false;
    }
    if (widget.maxValue != null && _value + widget.steps > widget.maxValue!) {
      return false;
    }
    return true;
  }

  bool canDecrement() {
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
    super.initState();
    _value = widget.initialValue;
    if (widget.controller == null) {
      _controller = ValueSteppersController.fromValue(
        initialValue: widget.initialValue,
        steps: widget.steps,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    } else {
      _controller = widget.controller!;
      _controller.setInitialValues(
        initialValue: widget.initialValue,
        steps: widget.steps,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.text, style: widget.labelTextStyle ?? TextStyle(fontSize: widget.textFontSize ?? 14)),
              const Spacer(),
              Text(_value.toString(), style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize ?? 14)),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          Row(
            children: [
              const Spacer(),
              IconButton.filledTonal(
                icon: widget.decrementIcon,
                onPressed: canDecrement() ? () {
                  if (canDecrement()) _controller.decrement();
                } : null,
              ),
              IconButton.filledTonal(
                icon: widget.incrementIcon,
                onPressed: canIncrement() ? () {
                  if (canIncrement()) _controller.increment();
                } : null,
              ),
            ],
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}