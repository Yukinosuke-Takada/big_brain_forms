part of '../../big_brain_forms.dart';

/// Abbreviations for the year. Used in [Year.withFormat].
enum YearAbbreviation {
  /// [integer] - ex: 2023, -2023
  integer,
  /// [bc] - ex: 2023, -2023 BC
  bc,
  /// [bcAd] - ex: AD 2023, -2023 BC
  bcAd,
  /// [bce] - ex: 2023, -2023 BCE
  bce,
  /// [bceCe] - ex: 2023 CE, -2023 BCE
  bceCe,
}

/// Year Object. Stores the year as an int. Specifically designed for the [YearSliderController].
class Year {
  /// Creates a [Year] from an integer.
  Year(this.year);

  /// The year as an int.
  int year;

  /// Returns the year as a [String] with the specified [YearAbbreviation].
  /// 
  /// [abbreviation] - The abbreviation to use for the year.
  /// [useMillionBillionSuffix] - Whether to use the million or billion suffix for large numbers.
  /// [useMillionSuffixAfter] - The number to use the million suffix after.
  /// [useBillionSuffixAfter] - The number to use the billion suffix after.
  /// [precisionForSuffix] - How many digits after the decimal point when using the million or billion suffix.
  String withFormat({
    YearAbbreviation abbreviation = YearAbbreviation.bc,
    bool useMillionBillionSuffix = true,
    int useMillionSuffixAfter = 100000,
    int useBillionSuffixAfter = 100000000,
    int? precisionForSuffix = 4,
  }) {
    // Returns the year as normal int to string.
    if (abbreviation == YearAbbreviation.integer) {
      return year.toString();
    }

    final isPositive = year >= 0;
    final absYear = year.abs();
    
    // Check if the year should use either suffix.
    final useBillionSuffixForThisYear = useMillionBillionSuffix && absYear >= useBillionSuffixAfter;
    final useMillionSuffixForThisYear = useMillionBillionSuffix && absYear >= useMillionSuffixAfter;
    late final String absYearFormatted;
    if (useBillionSuffixForThisYear) {
      final absYearInBillions = absYear / 1000000000;

      if (precisionForSuffix == null) {
        absYearFormatted = '$absYearInBillions billion';
      } else {
        final absYearWithPrecision = absYearInBillions.toStringAsFixed(precisionForSuffix);
        // Hacky way to remove trailing zeros.
        final absYearWithPrecisionNoTrailing = double.parse(absYearWithPrecision).toString();
        absYearFormatted = '$absYearWithPrecisionNoTrailing billion';
      }
    } else if (useMillionSuffixForThisYear) {
      final absYearInMillions = absYear / 1000000;

      if (precisionForSuffix == null) {
        absYearFormatted = '$absYearInMillions million';
      } else {
        final absYearWithPrecision = absYearInMillions.toStringAsFixed(precisionForSuffix);
        // Hacky way to remove trailing zeros.
        final absYearWithPrecisionNoTrailing = double.parse(absYearWithPrecision).toString();
        absYearFormatted = '$absYearWithPrecisionNoTrailing million';
      }
    } else {
      absYearFormatted = absYear.toString();
    }

    switch (abbreviation) {
      case YearAbbreviation.bc:
        return isPositive ? absYearFormatted : '$absYearFormatted BC';
      case YearAbbreviation.bcAd:
        // Ad is written before the year!
        return isPositive ? 'AD $absYearFormatted' : '$absYearFormatted BC';
      case YearAbbreviation.bce:
        return isPositive ? absYearFormatted : '$absYearFormatted BCE';
      case YearAbbreviation.bceCe:
        // Ce is written after the year!
        return isPositive ? '$absYearFormatted CE' : '$absYearFormatted BCE';
      case YearAbbreviation.integer:
        throw Exception('should not reach here');
    }
  }

  @override
  String toString() {
    return year.toString();
  }
}

/// Controller for a year slider. Stores the current value of the year.
class YearSliderController extends ChangeNotifier {
  /// Creates a [YearSliderController] with an initial value of 0.
  factory YearSliderController() {
    return YearSliderController.fromValue(
      initialYear: 0,
    );
  }

  /// Creates a [YearSliderController] with the given parameters.
  YearSliderController.fromValue({
    required int initialYear,
  })  : value = Year(initialYear), initialValue = Year(initialYear);

  /// Initial value of the year slider. Initial Value is used when resetting the year slider.
  Year initialValue;
  /// The stored value of the year slider.
  Year value;

  /// Sets the initial value of the year slider. Used for initializing the controller after its passed to the widget.
  void setInitialValues({
    required int initialYear,
  }) {
    initialValue = Year(initialYear);
    value = initialValue;
  }

  /// Sets the value of the year slider.
  void setValue(Year value) {
    this.value = value;
    notifyListeners();
  }

  /// Returns the current value of the year slider.
  Year getValue() {
    return value;
  }

  /// Sets the value to the value passed down from the slider.
  void onSliderChange(double value) {
    final year = Year(value.toInt());
    this.value = year;
    notifyListeners();
  }

  /// Resets the value of the year slider to the initial value.
  void reset() {
    value = initialValue;
    notifyListeners();
  }
}
