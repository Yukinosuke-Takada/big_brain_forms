part of '../../big_brain_forms.dart';

class YearSlider extends StatefulWidget {
  final int initialYear;
  final int minYear;
  final int maxYear;
  final bool readOnly;
  final void Function(Year value)? onValueChanged;
  final String text;

  const YearSlider({
    super.key,
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
    _controller = YearSliderController(
      initialYear: widget.initialYear,
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
              Text(_value.withFormat()),
            ],
          ),
          Slider(
            value: _value.year.toDouble(),
            min: widget.minYear.toDouble(),
            max: widget.maxYear.toDouble(),
            onChanged: (value) {
              _controller.onSliderChange(value);
            },
          )
        ],
      ),
    );
  }
}