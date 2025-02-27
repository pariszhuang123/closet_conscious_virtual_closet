class FormattedNumber {
  final num value;
  final String suffix;

  FormattedNumber(this.value, this.suffix);
}

FormattedNumber formatNumber(num number) {
  if (number < 10) {
    return FormattedNumber((number * 10).round() / 10, ''); // 1 decimal place
  } else if (number < 1000) {
    return FormattedNumber(number.round(), ''); // Keep as int when below 1000
  } else if (number < 1000000) {
    double val = (number / 1000 * 10).round() / 10;
    return FormattedNumber(val, 'K');
  } else if (number < 1000000000) {
    double val = (number / 1000000 * 10).round() / 10;
    return FormattedNumber(val, 'M');
  } else if (number < 1000000000000) {
    double val = (number / 1000000000 * 10).round() / 10;
    return FormattedNumber(val, 'B');
  } else {
    double val = (number / 1000000000000 * 10).round() / 10;
    return FormattedNumber(val, 'T');
  }
}
