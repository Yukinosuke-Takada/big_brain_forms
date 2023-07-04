part of '../../big_brain_forms.dart';

class ValueSteppersController {
  int initialValue;
  int value;
  int steps;
  void Function(int value)? onValueChanged;

  ValueSteppersController.fromValue({
    required this.initialValue,
    required this.steps,
    this.onValueChanged,
  }) : value = initialValue;

  factory ValueSteppersController() {
    return ValueSteppersController.fromValue(
      initialValue: 0,
      steps: 1,
    );
  }

  void setInitialValues({
    required int initialValue,
    required int steps,
    void Function(int value)? onValueChanged,
  }) {
    this.initialValue = initialValue;
    this.steps = steps;
    this.onValueChanged = onValueChanged;
    value = initialValue;
  }

  int getValue() {
    return value;
  }

  void setValue(int value) {
    this.value = value;
    onValueChanged?.call(value);
  }

  void increment() {
    value += steps;
    onValueChanged?.call(value);
  }

  void decrement() {
    value -= steps;
    onValueChanged?.call(value);
  }

  void reset() {
    value = initialValue;
    onValueChanged?.call(value);
  }
}
