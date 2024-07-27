class FormattedNumber {
  final int value;
  final String suffix;

  FormattedNumber(this.value, this.suffix);
}

FormattedNumber formatNumber(num number) {
  if (number < 1000) {
    return FormattedNumber(number.toInt(), '');
  } else if (number < 1000000) {
    return FormattedNumber((number / 1000).round(), 'K');
  } else if (number < 1000000000) {
    return FormattedNumber((number / 1000000).round(), 'M');
  } else if (number < 1000000000000) {
    return FormattedNumber((number / 1000000000).round(), 'B');
  } else {
    return FormattedNumber((number / 1000000000000).round(), 'T');
  }
}
