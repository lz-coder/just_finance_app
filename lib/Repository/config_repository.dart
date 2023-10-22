import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';

final coreDatabase = CoreDatabase();

class ConfigRepository extends ChangeNotifier {
  Locale? _currentLocale;

  set currentLocale(Locale? value) {
    _currentLocale = value;
    notifyListeners();
  }

  Future<void> changeCurrentLocale(Locale? locale) async {
    _currentLocale = locale;
    await coreDatabase.updateConfig(
        'locale_config', '${locale!.languageCode}_${locale.countryCode}');
    notifyListeners();
  }

  Locale? get currentLocale => _currentLocale;
}
