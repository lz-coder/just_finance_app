import 'package:intl/intl.dart';

class Currency {
  String? locale;

  Currency({this.locale});

  String showValueWithSymbol(num value) {
    return NumberFormat.currency(
            locale: locale, symbol: getCurrencySymbol(locale ?? 'en_null'))
        .format(value);
  }

  String showValue(num value) {
    return NumberFormat("#,##0.00", locale).format(value);
  }

  double parseValueToDouble(String value) {
    return NumberFormat("#,##0.00", locale).parse(value).toDouble();
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
