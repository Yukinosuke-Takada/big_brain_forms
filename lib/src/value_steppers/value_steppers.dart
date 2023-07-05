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
  });

  @override
  State<ValueSteppers> createState() => _ValueSteppersState();
}

class _ValueSteppersState extends State<ValueSteppers> {
  ValueSteppersController? _localController;
  ValueSteppersController get _effectiveController =>
      widget.controller ?? _localController!;
  late int _value;

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
    _value = widget.initialValue;
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
    _localController?.dispose();
    super.dispose();
  }

  void _handleValueChange() {
    final int newValue = _effectiveController.getValue();
    widget.onValueChanged?.call(newValue);
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.text),
              const Spacer(),
              Text(_value.toString()),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (canDecrement()) {
                    _effectiveController.decrement();
                  }
                },
                child: Icon(
                  Icons.remove,
                  color: canDecrement() ? null : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (canIncrement()) {
                    _effectiveController.increment();
                  }
                },
                child: Icon(
                  Icons.add,
                  color: canIncrement() ? null : Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}