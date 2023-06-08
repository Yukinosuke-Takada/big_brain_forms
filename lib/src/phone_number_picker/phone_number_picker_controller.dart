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
    return '+${countryCodeAsString()} ${phoneNumberAsString()}';
  }
}

class PhoneNumberPickerController {
  PhoneNumber phoneNumber;
  final void Function(PhoneNumber phoneNumber) onValueChanged;

  PhoneNumberPickerController({
    required PhoneNumber initialPhoneNumber,
    required this.onValueChanged,
  }) : phoneNumber = initialPhoneNumber;

  /// Manually set the value of the [PhoneNumberPickerController].
  void setValue (PhoneNumber phoneNumber) {
    this.phoneNumber = phoneNumber;
    onValueChanged(phoneNumber);
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
    onValueChanged(phoneNumber);
  }

  void setCountryCode(int value) {
    // check if value is valid
    if (value < 0) {
      throw const FormatException('countryCode must be larger or equal to 0.');
    }
    phoneNumber.countryCode = value;
    onValueChanged(phoneNumber);
  }

  void addDigit() {
    phoneNumber.digits.add(0);
    onValueChanged(phoneNumber);
  }

  void removeDigit() {
    phoneNumber.digits.removeLast();
    onValueChanged(phoneNumber);
  }
}

