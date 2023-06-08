part of '../../big_brain_forms.dart';

final List<DropdownMenuItem<int>> _items = List.generate(
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
  final String initialPhoneNumber;
  final bool useCountryCode;
  final int? initialCountryCode;
  final bool readOnly;
  final void Function(PhoneNumber value)? onValueChanged;
  final String text;

  const PhoneNumberPicker({
    super.key,
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
  late PhoneNumberPickerController _controller;
  late PhoneNumber _value;

  void _onValueChanged(PhoneNumber value) {
    setState(() {
      _value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _value = PhoneNumber(
      widget.initialPhoneNumber,
      countryCode: widget.useCountryCode ? widget.initialCountryCode : null,
    );
    _controller = PhoneNumberPickerController(
      initialPhoneNumber: _value,
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
                                _controller.setValue(
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
                        items: _items,
                        onChanged: widget.readOnly
                            ? null
                            : (value) {
                                _controller.setDigit(index, value as int);
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
                  _controller.removeDigit();
                },
                child: Icon(
                  Icons.remove,
                  color: widget.readOnly ? Colors.grey : null,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.addDigit();
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
