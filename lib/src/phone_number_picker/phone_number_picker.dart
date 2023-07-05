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
  final double? textFontSize;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final TextStyle? pickerTextStyle;
  final double pickerSpacingIndex;
  final Icon incrementIcon;
  final Icon decrementIcon;
  final double labelBottomPadding;
  final double bottomPadding;

  const PhoneNumberPicker({
    super.key,
    this.controller,
    this.initialPhoneNumber = '0000000000',
    this.useCountryCode = false,
    this.initialCountryCode,
    this.readOnly = false,
    this.onValueChanged,
    required this.text,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.pickerTextStyle,
    this.pickerSpacingIndex = 1.0,
    this.incrementIcon = const Icon(Icons.add),
    this.decrementIcon = const Icon(Icons.remove),
    this.labelBottomPadding = 8.0,
    this.bottomPadding = 18.0,
  });

  @override
  State<PhoneNumberPicker> createState() => _PhoneNumberPickerState();
}

class _PhoneNumberPickerState extends State<PhoneNumberPicker> {
  late PhoneNumberPickerController _controller;
  late PhoneNumber _value;

  late final ScrollController _scrollController;

  double _scrollPosition = 0.0;
  double _scrollMax = 0.0;

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
    if (widget.controller == null) {
      _controller = PhoneNumberPickerController.fromValue(
        initialPhoneNumber: _value,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    } else {
      _controller = widget.controller!;
      _controller.setInitialValues(
        initialPhoneNumber: _value,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    }

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _setScrollPositions();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setScrollPositions();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setScrollPositions() {
    final double currentScrollPosition = _scrollController.position.pixels;
    final double currentScrollMax = _scrollController.position.maxScrollExtent;
    if (currentScrollPosition < 0 && _scrollPosition < 0) {
      return;
    }
    if (currentScrollPosition > currentScrollMax && _scrollPosition > currentScrollMax) {
      return;
    }
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      _scrollMax = _scrollController.position.maxScrollExtent;
    });
  }

  bool canIncrement() {
    if (widget.readOnly) {
      return false;
    }
    return true;
  }

  bool canDecrement() {
    if (widget.readOnly) {
      return false;
    }
    if (_value.digits.isEmpty) {
      return false;
    }
    return true;
  }

  int _to255(double value) {
    if (value < 0) {
      return 0;
    }
    if (value > 255) {
      return 255;
    }
    return value.floor();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.text, style: widget.labelTextStyle ?? TextStyle(fontSize: widget.textFontSize ?? 14)),
              const SizedBox(
                width: 32.0,
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _value.toString(),
                    style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize ?? 14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          ShaderMask(
            shaderCallback: (Rect rect) {
              final Color startColor = _scrollPosition < 50 ? Color.fromARGB(255 -_to255(_scrollPosition / 50 * 255), 0, 0, 0) : Colors.transparent;
              final Color endColor = _scrollPosition > _scrollMax - 50 ? Color.fromARGB(255 - _to255((_scrollMax - _scrollPosition) / 50 * 255), 0, 0, 0) : Colors.transparent;
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  startColor,
                  Colors.black,
                  Colors.black,
                  endColor,
                ],
                stops: const [
                  0.0,
                  0.2,
                  0.8,
                  1.0,
                ],
              ).createShader(rect);
            },
            child: SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: [
                      SizedBox(width: (widget.textFontSize ?? 14) * 0.4 * widget.pickerSpacingIndex),
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
                          style: widget.pickerTextStyle ?? TextStyle(fontSize: (widget.textFontSize ?? 14) + 2, color: Colors.black),
                          underline: Container(),
                        ),
                        SizedBox(width: (widget.textFontSize ?? 14) * 1.2 * widget.pickerSpacingIndex),
                      ],
                      ...List.generate(
                        _value.digits.length,
                        (index) => Row(
                          children: [
                            DropdownButton(
                              value: _value.digits[index],
                              items: _digitItems,
                              onChanged: widget.readOnly
                                  ? null
                                  : (value) {
                                      _controller.setDigit(index, value as int);
                                    },
                              style: widget.pickerTextStyle ?? TextStyle(fontSize: (widget.textFontSize ?? 14) + 2, color: Colors.black),
                              underline: Container(),
                            ),
                            SizedBox(width: (widget.textFontSize ?? 14) * 0.4 * widget.pickerSpacingIndex),
                          ],
                        ),
                      ),
                    ]
                  ),
                )
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              IconButton.filledTonal(
                icon: widget.decrementIcon,
                onPressed: canDecrement() ? () {
                  if (canDecrement()) _controller.removeDigit();
                  _setScrollPositions();
                } : null,
              ),
              IconButton.filledTonal(
                icon: widget.incrementIcon,
                onPressed: canIncrement() ? () {
                  if (canIncrement()) _controller.addDigit();
                  _setScrollPositions();
                } : null,
              ),
            ],
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}
