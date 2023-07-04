part of '../../big_brain_forms.dart';

class PhoneNumber {
  // [2, 0, 6, 5, 5, 5, 0, 1, 0, 0]
  List<int> digits;
  
  int? countryCode;

  /// Creates a [PhoneNumber] from a [List] of digits. ex: [2, 0, 6, 5, 5, 5, 0, 1, 0, 0]
  PhoneNumber.fromList(this.digits, {this.countryCode});

  /// Creates a [PhoneNumber] from a [String] phoneNumber. ex: '2065550100'
  factory PhoneNumber(String initialPhoneNumber, {int? countryCode}) {
    // check if phoneNumber can be parsed to int
    if (initialPhoneNumber == '') {
      return PhoneNumber.fromList([], countryCode: countryCode);
    }
    if (int.tryParse(initialPhoneNumber) == null) {
      throw const FormatException('phoneNumber must be a number');
    }
    return PhoneNumber.fromList(initialPhoneNumber.split('').map(int.parse).toList(), countryCode: countryCode);
  }

  String phoneNumberAsString() {
    return digits.join();
  }
  
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

class PhoneNumberPickerController {
  PhoneNumber phoneNumber;
  void Function(PhoneNumber phoneNumber)? onValueChanged;
  PhoneNumber initialPhoneNumber;

  // PhoneNumberPickerController({
  //   required this.initialPhoneNumber,
  //   required this.onValueChanged,
  // }) : phoneNumber = initialPhoneNumber;

  PhoneNumberPickerController.fromValue({
    required this.initialPhoneNumber,
    this.onValueChanged,
  }) : phoneNumber = initialPhoneNumber;

  factory PhoneNumberPickerController() {
    return PhoneNumberPickerController.fromValue(
      initialPhoneNumber: PhoneNumber(''),
    );
  }

  void setInitialValues({
    required PhoneNumber initialPhoneNumber,
    void Function(PhoneNumber phoneNumber)? onValueChanged,
  }) {
    this.initialPhoneNumber = initialPhoneNumber;
    this.onValueChanged = onValueChanged;
    phoneNumber = initialPhoneNumber;
  }

  /// Manually set the value of the [PhoneNumberPickerController].
  void setValue (PhoneNumber phoneNumber) {
    this.phoneNumber = phoneNumber;
    onValueChanged?.call(phoneNumber);
  }

  PhoneNumber getValue() {
    return phoneNumber;
  }

  void setDigit(int index, int value) {
    // check if value is a digit
    if (value < 0 || 9 < value) {
      throw const FormatException('value must be a digit.');
    }
    // check if index is valid
    if (index < 0 || phoneNumber.digits.length <= index) {
      throw const FormatException('index must be within the range of the phoneNumber length.');
    }

    phoneNumber.digits[index] = value;
    onValueChanged?.call(phoneNumber);
  }

  void setCountryCode(int value) {
    // check if value is valid
    if (value < 0) {
      throw const FormatException('countryCode must be larger or equal to 0.');
    }
    phoneNumber.countryCode = value;
    onValueChanged?.call(phoneNumber);
  }

  void addDigit() {
    phoneNumber.digits.add(0);
    onValueChanged?.call(phoneNumber);
  }

  void removeDigit() {
    phoneNumber.digits.removeLast();
    onValueChanged?.call(phoneNumber);
  }

  void reset() {
    phoneNumber = initialPhoneNumber;
    onValueChanged?.call(phoneNumber);
  }
}

