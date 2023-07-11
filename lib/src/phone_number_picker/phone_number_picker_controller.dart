part of '../../big_brain_forms.dart';

/// Phone number Object. Stores the digits of a phone number and the country code. Specifically designed for the
/// [PhoneNumberPickerController].
class PhoneNumber {
  /// The digits of the phone number. Stored as List of integers. ex: '2065550100' -> [2, 0, 6, 5, 5, 5, 0, 1, 0, 0]
  List<int> digits;
  /// The country code of the phone number. ex: '+1' -> 1
  int? countryCode;

  /// Creates a [PhoneNumber] from a [List] of digits. ex: [2, 0, 6, 5, 5, 5, 0, 1, 0, 0]
  PhoneNumber.fromList(this.digits, {this.countryCode});

  /// Creates a [PhoneNumber] from a [String] phoneNumber. ex: '2065550100'
  factory PhoneNumber(String initialPhoneNumber, {int? countryCode}) {
    if (initialPhoneNumber == '') {
      return PhoneNumber.fromList([], countryCode: countryCode);
    }
    // check if phoneNumber can be parsed to int
    if (int.tryParse(initialPhoneNumber) == null) {
      throw const FormatException('phoneNumber must be a number');
    }
    return PhoneNumber.fromList(initialPhoneNumber.split('').map(int.parse).toList(), countryCode: countryCode);
  }

  /// Returns the phoneNumber as a [String]. ex: '2065550100'
  String phoneNumberAsString() {
    return digits.join();
  }

  /// Returns the countryCode as a [String]. ex: '1'
  String countryCodeAsString() {
    return countryCode?.toString() ?? '';
  }

  @override
  String toString() {
    if (countryCode == null) {
      return phoneNumberAsString();
    } else {
      return '+${countryCodeAsString()} ${phoneNumberAsString()}';
    }
  }
}

/// Controller for a phone number picker. Stores the current value of the phone number and the country code.
class PhoneNumberPickerController extends ChangeNotifier {
  /// Initial value of the phone number picker. Initial Value is used when resetting the phone number picker.
  PhoneNumber initialValue;
  /// The stored value of the phone number picker.
  PhoneNumber value;

  PhoneNumberPickerController.fromValue({
    required this.initialValue,
  }) : value = initialValue;

  /// Creates a [PhoneNumberPickerController] with an empty phoneNumber.
  factory PhoneNumberPickerController() {
    return PhoneNumberPickerController.fromValue(
      initialValue: PhoneNumber(''),
    );
  }

  /// Sets the initial value of the phoneNumber. Used for initializing the controller after its passed to the
  /// widget. Does not notify listeners.
  void setInitialValues({
    required PhoneNumber initialPhoneNumber,
  }) {
    initialValue = initialPhoneNumber;
    value = initialPhoneNumber;
  }

  /// Sets the value of the phoneNumber.
  void setValue (PhoneNumber phoneNumber) {
    value = phoneNumber;
    notifyListeners();
  }

  /// Returns the current value of the phoneNumber.
  PhoneNumber getValue() {
    return value;
  }

  /// Sets the digit at the given index to the given value.
  void setDigit(int index, int v) {
    // check if value is a digit
    if (v < 0 || 9 < v) {
      throw const FormatException('value must be a digit.');
    }
    // check if index is valid
    if (index < 0 || value.digits.length <= index) {
      throw const FormatException('index must be within the range of the phoneNumber length.');
    }

    value.digits[index] = v;
    notifyListeners();
  }

  /// Sets the country code.
  void setCountryCode(int v) {
    // check if value is valid
    if (v < 0) {
      throw const FormatException('countryCode must be larger or equal to 0.');
    }
    value.countryCode = v;
    notifyListeners();
  }

  /// Adds a digit to the phoneNumber. Adds a 0 to the end of the phoneNumber.
  void addDigit() {
    value.digits.add(0);
    notifyListeners();
  }

  /// Removes a digit from the phoneNumber. Removes the last digit of the phoneNumber.
  void removeDigit() {
    value.digits.removeLast();
    notifyListeners();
  }

  /// Resets the value to the initial value.
  void reset() {
    value = initialValue;
    notifyListeners();
  }
}

