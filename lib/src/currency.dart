import 'package:intl/intl.dart';

class Currency {
  String? locale;

  Currency({this.locale});

  String show(num value) {
    return NumberFormat.currency(
            locale: locale, symbol: getCurrencySymbol(locale ?? 'en_null'))
        .format(value);
  }

  String showMinimum(double value) {
    return NumberFormat.simpleCurrency(locale: locale).format(value);
  }

  String showValueOnly(num value) {
    return NumberFormat("#,##0.00", locale).format(value);
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
