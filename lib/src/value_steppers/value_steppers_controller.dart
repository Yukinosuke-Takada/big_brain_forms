part of '../../big_brain_forms.dart';

class ValueSteppersController extends ChangeNotifier {
  int initialValue;
  int value;
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

  void setInitialValues({
    required int initialValue,
    required int steps,
  }) {
    this.initialValue = initialValue;
    this.steps = steps;
    value = initialValue;
  }

  int getValue() {
    return value;
  }

  void setValue(int value) {
    this.value = value;
    notifyListeners();
  }

  void increment() {
    value += steps;
    notifyListeners();
  }

  void decrement() {
    value -= steps;
    notifyListeners();
  }

  void reset() {
    value = initialValue;
    notifyListeners();
  }
}
