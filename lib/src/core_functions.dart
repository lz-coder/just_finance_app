import 'package:flutter/material.dart';

String getCurrentLocale(BuildContext context) {
  return '${Localizations.localeOf(context).languageCode}_${Localizations.localeOf(context).countryCode}';
}
