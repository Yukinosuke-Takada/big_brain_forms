part of '../../big_brain_forms.dart';

/// Controller for a value stepper. Stores the current value of the stepper and the number of steps to increment or
/// decrement the value. Can be used to reset the stepper to its initial value.
class ValueSteppersController extends ChangeNotifier {
  /// Initial value of the stepper. Initial Value is used when resetting the stepper.
  int initialValue;
  /// The stored value of the stepper.
  int value;
  /// The number of steps to increment or decrement the value.
  int steps;

  ValueSteppersController.fromValue({
    required this.initialValue,
    required this.steps,
  }) : value = initialValue;

  factory ValueSteppersController() {
    return ValueSteppersController.fromValue(
      initialValue: 0,
      steps: 1,
    );
  }

  /// Sets the initial value and steps of the stepper. Used for initializing the controller after its passed to the 
  /// widget. Does not notify listeners.
  void setInitialValues({
    required int initialValue,
    required int steps,
  }) {
    this.initialValue = initialValue;
    this.steps = steps;
    value = initialValue;
  }

  /// Sets the value of the stepper.
  void setValue(int value) {
    this.value = value;
    notifyListeners();
  }

  /// Returns the current value of the stepper.
  int getValue() {
    return value;
  }

  /// Increments the value of the stepper by the number of steps.
  void increment() {
    value += steps;
    notifyListeners();
  }

  /// Decrements the value of the stepper by the number of steps.
  void decrement() {
    value -= steps;
    notifyListeners();
  }

  /// Resets the value of the stepper to the initial value.
  void reset() {
    value = initialValue;
    notifyListeners();
  }
}
