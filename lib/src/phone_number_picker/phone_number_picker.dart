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
  PhoneNumberPickerController? _localController;
  PhoneNumberPickerController get _effectiveController =>
      widget.controller ?? _localController!;
  late PhoneNumber _value;

  late final ScrollController _scrollController;
  double _scrollPosition = 0.0;
  double _scrollMax = 0.0;

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

    _scrollController = ScrollController();
    _scrollController.addListener(_setScrollPositions);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setScrollPositions();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

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
      _scrollPosition = currentScrollPosition;
      _scrollMax = currentScrollMax;
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
              Text(
                widget.text,
                style: widget.labelTextStyle ?? TextStyle(fontSize: widget.textFontSize),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _value.toString(),
                    style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          ShaderMask(
            shaderCallback: (Rect rect) {
              final Color startColor = _scrollPosition < 50
                  ? Color.fromARGB(255 - _to255(_scrollPosition / 50 * 255), 0, 0, 0)
                  : Colors.transparent;
              final Color endColor = _scrollMax - _scrollPosition < 50
                  ? Color.fromARGB(255 - _to255((_scrollMax - _scrollPosition) / 50 * 255), 0, 0, 0)
                  : Colors.transparent;
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[startColor, Colors.black, Colors.black, endColor],
                stops: const <double>[0.0, 0.2, 0.8, 1.0],
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
                      SizedBox(
                        width: (widget.textFontSize ?? 14) * 0.4 * widget.pickerSpacingIndex,
                      ),
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
                          style: widget.pickerTextStyle ??
                              TextStyle(
                                fontSize: (widget.textFontSize ?? 14) + 2,
                                color: Colors.black,
                              ),
                          underline: Container(),
                        ),
                        SizedBox(
                          width: (widget.textFontSize ?? 14) * 1.2 * widget.pickerSpacingIndex,
                        ),
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
                                      _effectiveController.setDigit(index, value as int);
                                    },
                              style: widget.pickerTextStyle ??
                                  TextStyle(
                                    fontSize: (widget.textFontSize ?? 14) + 2,
                                    color: Colors.black,
                                  ),
                              underline: Container(),
                            ),
                            SizedBox(
                              width: (widget.textFontSize ?? 14) * 0.4 * widget.pickerSpacingIndex,
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                )
              ),
            )
          ),
          Row(
            children: [
              const Spacer(),
              IconButton.filledTonal(
                onPressed: canDecrement() ? () {
                  if (canDecrement()) _effectiveController.removeDigit();
                  _setScrollPositions();
                } : null,
                icon: widget.decrementIcon,
              ),
              IconButton.filledTonal(
                onPressed: canIncrement() ? () {
                  if (canIncrement()) _effectiveController.addDigit();
                  _setScrollPositions();
                } : null,
                icon: widget.incrementIcon,
              ),
            ],
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}
