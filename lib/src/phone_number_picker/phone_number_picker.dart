part of '../../big_brain_forms.dart';

/// Literally [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as DropdownMenuItems.
final List<DropdownMenuItem<int>> _digitItems = List.generate(
  10,
  (index) => DropdownMenuItem(
    value: index,
    child: Text(index.toString()),
  ),
);

/// ['+1', '+2', '+3', ...] as DropdownMenuItems.
final List<DropdownMenuItem<int>> _countryCodeItems = List.generate(
  1000,
  (index) => DropdownMenuItem(
    value: index,
    child: Text('+$index'),
  ),
);

/// A complimentary widget. A phone number field where you have to select each digit from a dropdown menu.
class PhoneNumberPicker extends StatefulWidget {
  /// Creates a phone number field where you have to select each digit from a dropdown menu.
  const PhoneNumberPicker({
    required this.labelText,
    super.key,
    this.controller,
    this.initialPhoneNumber = '0000000000',
    this.useCountryCode = false,
    this.initialCountryCode,
    this.readOnly = false,
    this.onValueChanged,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.pickerTextStyle,
    this.pickerSpacingIndex = 1.0,
    this.incrementIcon = const Icon(Icons.add),
    this.decrementIcon = const Icon(Icons.remove),
    this.labelBottomPadding = 8.0,
    this.bottomPadding = 18.0,
  }) : assert(
          !useCountryCode || initialCountryCode != null,
          'useCountryCode must be true if initialCountryCode is null',
        );

  /// The controller for the phone number picker. The passed controller with be initialized with the given parameters:
  /// [initialPhoneNumber], [initialCountryCode]. If null, a local controller will be created.
  final PhoneNumberPickerController? controller;
  /// The initial value of the phone number picker.
  final String initialPhoneNumber;
  /// Whether the phone number picker should use a country code. If true, additional dropdown menu will be added to the
  /// left of the phone number dropdown menus.
  final bool useCountryCode;
  /// The initial country code of the phone number picker. Make sure that [useCountryCode] is true.
  final int? initialCountryCode;
  /// Whether the phone number picker is read only. If true, the phone number picker cannot be changed and greyed out.
  final bool readOnly;
  /// Callback function for when the value of the phone number picker changes.
  final void Function(PhoneNumber value)? onValueChanged;
  /// The text to display above the phone number picker.
  final String labelText;
  /// The font size of the label and value and dropdown menu items. The dropdown menu items are slightly larger than
  /// the other with [textFontSize] + 2. 
  final double? textFontSize;
  /// The text style of the label.
  final TextStyle? labelTextStyle;
  /// The text style of the value.
  final TextStyle? valueTextStyle;
  /// The text style of the dropdown menu items.
  final TextStyle? pickerTextStyle;
  /// The spacing index of the dropdown menu items.
  /// 
  /// The spacing of the either end of the dropdown menu items is [textFontSize] * 0.4 * [pickerSpacingIndex].
  /// The spacing between the dropdown menu items is [textFontSize] * 0.8 * [pickerSpacingIndex].
  /// If country code is used, the spacing between the country code dropdown menu and the phone number dropdown menus
  /// is [textFontSize] * 1.2 * [pickerSpacingIndex].
  final double pickerSpacingIndex;
  /// The icon for the increment button.
  final Icon incrementIcon;
  /// The icon for the decrement button.
  final Icon decrementIcon;
  /// The padding between the label and the phone number picker.
  final double labelBottomPadding;
  /// The padding at the bottom of this widget.
  final double bottomPadding;

  @override
  State<PhoneNumberPicker> createState() => _PhoneNumberPickerState();
}

class _PhoneNumberPickerState extends State<PhoneNumberPicker> {
  /// The local controller for the phone number picker. Only used if widget.controller is null.
  PhoneNumberPickerController? _localController;
  // Returns the effective controller.
  PhoneNumberPickerController get _effectiveController => widget.controller ?? _localController!;

  /// The current value of the phone number picker.
  late PhoneNumber _value;

  /// The scroll controller for the singleScrollView that contains the dropdown menus.
  late final ScrollController _scrollController;
  /// The current scroll position and max scroll position of the singleScrollView.
  double _scrollPosition = 0;
  double _scrollMax = 0;

  @override
  void initState() {
    // Initialize the value of the phone number picker.
    _value = PhoneNumber(
      widget.initialPhoneNumber,
      countryCode: widget.useCountryCode ? widget.initialCountryCode : null,
    );
    // Initialize the controller.
    if (widget.controller == null) {
      _localController = PhoneNumberPickerController.fromValue(
        initialValue: _value,
      );
    } else {
      widget.controller!.setInitialValues(
        initialPhoneNumber: _value,
      );
    }
    _effectiveController.addListener(_handleValueChange);

    // Initialize the scroll controller.
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
    // Dispose the local controller if it was created.
    _localController?.dispose();
    super.dispose();
  }

  /// Callback function for when the value of the phone number picker changes.
  void _handleValueChange() {
    final newValue = _effectiveController.getValue();
    widget.onValueChanged?.call(newValue);
    setState(() {
      _value = newValue;
    });
  }

  /// Sets the scroll position and max scroll position of the singleScrollView and rerenders if necessary.
  void _setScrollPositions() {
    final currentScrollPosition = _scrollController.position.pixels;
    final currentScrollMax = _scrollController.position.maxScrollExtent;
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

  // Checks if the phone number digit can be added.
  bool _canIncrement() {
    if (widget.readOnly) {
      return false;
    }
    return true;
  }

  // Checks if the phone number digit can be removed.
  bool _canDecrement() {
    if (widget.readOnly) {
      return false;
    }
    if (_value.digits.isEmpty) {
      return false;
    }
    return true;
  }

  // Converts a double value to an int value and strips it to be between 0 and 255. Used for rbga values.
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.labelText,
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
          /// The end of the singleScrollView will have fade out effect if it can be scrolled in that direction.
          ShaderMask(
            shaderCallback: (Rect rect) {
              final startColor = _scrollPosition < 50
                  ? Color.fromARGB(255 - _to255(_scrollPosition / 50 * 255), 0, 0, 0)
                  : Colors.transparent;
              final endColor = _scrollMax - _scrollPosition < 50
                  ? Color.fromARGB(255 - _to255((_scrollMax - _scrollPosition) / 50 * 255), 0, 0, 0)
                  : Colors.transparent;
              return LinearGradient(
                colors: <Color>[startColor, Colors.black, Colors.black, endColor],
                stops: const <double>[0, 0.2, 0.8, 1],
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
                                      countryCode: value! as int,
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
                                      _effectiveController.setDigit(index, value! as int);
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              IconButton.filledTonal(
                onPressed: _canDecrement() ? () {
                  if (_canDecrement()) _effectiveController.removeDigit();
                  _setScrollPositions();
                } : null,
                icon: widget.decrementIcon,
              ),
              IconButton.filledTonal(
                onPressed: _canIncrement() ? () {
                  if (_canIncrement()) _effectiveController.addDigit();
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
