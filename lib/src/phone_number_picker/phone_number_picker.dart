part of '../../big_brain_forms.dart';

final List<DropdownMenuItem<int>> _digitItems = List.generate(
  10,
  (index) => DropdownMenuItem(
    value: index,
    child: Text(index.toString()),
  ),
);

final List<DropdownMenuItem<int>> _countryCodeItems = List.generate(
  1000,
  (index) => DropdownMenuItem(
    value: index,
    child: Text('+${index.toString()}'),
  ),
);

class PhoneNumberPicker extends StatefulWidget {
  final PhoneNumberPickerController? controller;
  final String initialPhoneNumber;
  final bool useCountryCode;
  final int? initialCountryCode;
  final bool readOnly;
  final void Function(PhoneNumber value)? onValueChanged;
  final String text;

  const PhoneNumberPicker({
    super.key,
    this.controller,
    this.initialPhoneNumber = '0000000000',
    this.useCountryCode = false,
    this.initialCountryCode,
    this.readOnly = false,
    this.onValueChanged,
    required this.text,
  });

  @override
  State<PhoneNumberPicker> createState() => _PhoneNumberPickerState();
}

class _PhoneNumberPickerState extends State<PhoneNumberPicker> {
  PhoneNumberPickerController? _localController;
  PhoneNumberPickerController get _effectiveController =>
      widget.controller ?? _localController!;
  late PhoneNumber _value;

  @override
  void initState() {
    _value = PhoneNumber(
      widget.initialPhoneNumber,
      countryCode: widget.useCountryCode ? widget.initialCountryCode : null,
    );
    if (widget.controller == null) {
      _localController = PhoneNumberPickerController.fromValue(
        initialPhoneNumber: _value,
      );
    } else {
      widget.controller!.setInitialValues(
        initialPhoneNumber: _value,
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
    final PhoneNumber newValue = _effectiveController.getValue();
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
          SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (widget.useCountryCode) ...[
                      DropdownButton(
                        value: _value.countryCode,
                        items: _countryCodeItems,
                        onChanged: widget.readOnly
                            ? null
                            : (value) {
                                _effectiveController.setValue(
                                  PhoneNumber.fromList(
                                    _value.digits,
                                    countryCode: value as int,
                                  ),
                                );
                              },
                      ),
                      const SizedBox(width: 8),
                    ],
                    ...List.generate(
                      _value.digits.length,
                      (index) => DropdownButton(
                        value: _value.digits[index],
                        items: _digitItems,
                        onChanged: widget.readOnly
                            ? null
                            : (value) {
                                _effectiveController.setDigit(index, value as int);
                              },
                      ),
                    ),
                  ]
                ),
              )
            ),
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  _effectiveController.removeDigit();
                },
                child: Icon(
                  Icons.remove,
                  color: widget.readOnly ? Colors.grey : null,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _effectiveController.addDigit();
                },
                child: Icon(
                  Icons.add,
                  color: widget.readOnly ? Colors.grey : null,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
