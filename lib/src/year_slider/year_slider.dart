part of '../../big_brain_forms.dart';

class YearSlider extends StatefulWidget {
  final YearSliderController? controller;
  final int initialYear;
  final int minYear;
  final int maxYear;
  final bool readOnly;
  final void Function(Year value)? onValueChanged;
  final String text;
  final double? textFontSize;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final double labelBottomPadding;
  final double bottomPadding;

  const YearSlider({
    super.key,
    this.controller,
    this.initialYear = 0,
    required this.minYear,
    required this.maxYear,
    this.readOnly = false,
    this.onValueChanged,
    required this.text,
    this.textFontSize,
    this.labelTextStyle,
    this.valueTextStyle,
    this.labelBottomPadding = 18.0,
    this.bottomPadding = 18.0,
  });

  @override
  State<YearSlider> createState() => _YearSliderState();
}

class _YearSliderState extends State<YearSlider> {
  late YearSliderController _controller;
  late Year _value;

  void _onValueChanged(Year value) {
    setState(() {
      _value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _value = Year(widget.initialYear);
    if (widget.controller == null) {
      _controller = YearSliderController.fromValue(
        initialYear: widget.initialYear,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    } else {
      _controller = widget.controller!;
      _controller.setInitialValues(
        initialYear: widget.initialYear,
        onValueChanged: (value) {
          _onValueChanged(value);
          widget.onValueChanged?.call(value);
        },
      );
    }
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
                    _value.withFormat(),
                    style: widget.valueTextStyle ?? TextStyle(fontSize: widget.textFontSize ?? 14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.labelBottomPadding),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: _value.year.toDouble(),
              min: widget.minYear.toDouble(),
              max: widget.maxYear.toDouble(),
              onChanged: (value) {
                _controller.onSliderChange(value);
              },
            ),
          ),
          SizedBox(height: widget.bottomPadding),
        ],
      ),
    );
  }
}