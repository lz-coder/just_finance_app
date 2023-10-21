import 'package:flutter/material.dart';

class ConfigRepository extends ChangeNotifier {
  Locale? _currentLocale;

  set currentLocale(Locale? value) {
    _currentLocale = value;
    notifyListeners();
  }

  Locale? get currentLocale => _currentLocale;
}
