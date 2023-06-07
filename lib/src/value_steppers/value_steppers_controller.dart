part of '../../big_brain_forms.dart';

class ValueSteppersController {
  final int initialValue;
  final int steps;
  final void Function(int value) onValueChanged;

  ValueSteppersController({
    required this.initialValue,
    required this.steps,
    required this.onValueChanged,
  }) : value = initialValue;

  int value;

  int getValue() {
    return value;
  }

  void setValue(int value) {
    this.value = value;
    onValueChanged(value);
  }

  void increment() {
    value += steps;
    onValueChanged(value);
  }

  void decrement() {
    value -= steps;
    onValueChanged(value);
  }
}
