import 'package:intl/intl.dart';

class Currency {
  String locale;

  Currency({required this.locale});

  String show(num value) {
    return NumberFormat.currency(
            locale: locale, symbol: getCurrencySymbol(locale))
        .format(value);
  }

  String showMinimum(double value) {
    return NumberFormat.simpleCurrency(locale: locale).format(value);
  }
}

String getCurrencySymbol(String locale) {
  switch (locale) {
    case 'en_null':
      return '\$';
    case 'pt_BR':
      return 'R\$';
    case 'pt_null':
      return '€';
    default:
      return '\$';
  }
}
