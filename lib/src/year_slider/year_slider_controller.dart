part of '../../big_brain_forms.dart';

enum YearAbbreviation {
  integer,
  bc,
  bcAd,
  bce,
  bceCe,
}

class Year {
  int year;
  Year(this.year);

  String withFormat({
    YearAbbreviation abbreviation = YearAbbreviation.bc,
    bool useMillionBillionSuffix = true,
    int useMillionSuffixAfter = 100000,
    int useBillionSuffixAfter = 100000000,
    /// How many digits after the decimal point when using the million or billion suffix.
    int? precisionForSuffix = 4,
  }) {
    // Returns the year as normal int to string.
    if (abbreviation == YearAbbreviation.integer) {
      return year.toString();
    }

    final bool isPositive = year >= 0;
    final int absYear = year.abs();
    
    // Check if the year should use either suffix.
    final bool useBillionSuffixForThisYear = useMillionBillionSuffix && absYear >= useBillionSuffixAfter;
    final bool useMillionSuffixForThisYear = useMillionBillionSuffix && absYear >= useMillionSuffixAfter;
    late final String absYearFormatted;
    if (useBillionSuffixForThisYear) {
      final double absYearInBillions = absYear / 1000000000;

      if (precisionForSuffix == null) {
        absYearFormatted = '$absYearInBillions billion';
      } else {
        final String absYearWithPrecision = absYearInBillions.toStringAsFixed(precisionForSuffix);
        // Hacky way to remove trailing zeros.
        final String absYearWithPrecisionNoTrailing = double.parse(absYearWithPrecision).toString();
        absYearFormatted = '$absYearWithPrecisionNoTrailing billion';
      }
    } else if (useMillionSuffixForThisYear) {
      final double absYearInMillions = absYear / 1000000;

      if (precisionForSuffix == null) {
        absYearFormatted = '$absYearInMillions million';
      } else {
        final String absYearWithPrecision = absYearInMillions.toStringAsFixed(precisionForSuffix);
        // Hacky way to remove trailing zeros.
        final String absYearWithPrecisionNoTrailing = double.parse(absYearWithPrecision).toString();
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
      default:
        throw Exception('should not reach here');
    }
  }

  @override
  String toString() {
    return year.toString();
  }
}

class YearSliderController extends ChangeNotifier {
  Year initialYear;
  Year value;

  YearSliderController.fromValue({
    required int initialYear,
  })  : value = Year(initialYear),
        initialYear = Year(initialYear);

  factory YearSliderController() {
    return YearSliderController.fromValue(
      initialYear: 0,
    );
  }

  void setInitialValues({
    required int initialYear,
  }) {
    this.initialYear = Year(initialYear);
    value = this.initialYear;
  }

  Year getValue() {
    return value;
  }

  void setValue(Year value) {
    this.value = value;
    notifyListeners();
  }

  void onSliderChange(double value) {
    final Year year = Year(value.toInt());
    this.value = year;
    notifyListeners();
  }

  void reset() {
    value = initialYear;
    notifyListeners();
  }
}
