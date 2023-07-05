part of '../../big_brain_forms.dart';

class YearSlider extends StatefulWidget {
  final YearSliderController? controller;
  final int initialYear;
  final int minYear;
  final int maxYear;
  final bool readOnly;
  final void Function(Year value)? onValueChanged;
  final String text;

  const YearSlider({
    super.key,
    this.controller,
    this.initialYear = 0,
    required this.minYear,
    required this.maxYear,
    this.readOnly = false,
    this.onValueChanged,
    required this.text,
  });

  @override
  State<YearSlider> createState() => _YearSliderState();
}

class _YearSliderState extends State<YearSlider> {
  YearSliderController? _localController;
  YearSliderController get _effectiveController =>
      widget.controller ?? _localController!;
  late Year _value;

  @override
  void initState() {
    _value = Year(widget.initialYear);
    if (widget.controller == null) {
      _localController = YearSliderController.fromValue(
        initialYear: widget.initialYear,
      );
    } else {
      widget.controller!.setInitialValues(
        initialYear: widget.initialYear,
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
    final Year newValue = _effectiveController.getValue();
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
              Text(_value.withFormat()),
            ],
          ),
          Slider(
            value: _value.year.toDouble(),
            min: widget.minYear.toDouble(),
            max: widget.maxYear.toDouble(),
            onChanged: (value) {
              _effectiveController.onSliderChange(value);
            },
          )
        ],
      ),
    );
  }
}