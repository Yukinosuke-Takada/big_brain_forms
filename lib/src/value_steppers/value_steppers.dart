part of '../../big_brain_forms.dart';

class ValueSteppers extends StatefulWidget {
  final int initialValue;
  final int? minValue;
  final int? maxValue;
  final int steps;
  final bool readOnly;
  final void Function(int value)? onValueChanged;
  final String text;

  const ValueSteppers({
    super.key,
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
    _controller = ValueSteppersController(
      initialValue: widget.initialValue,
      steps: widget.steps,
      onValueChanged: (value) {
        _onValueChanged(value);
        widget.onValueChanged?.call(value);
      },
    );
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
                    _controller.decrement();
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
                    _controller.increment();
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