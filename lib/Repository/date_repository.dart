import 'package:flutter/material.dart';

class DateRepository extends ChangeNotifier {
  int? _currentYear;
  int? _currentMonth;

  set currentYear(int? value) {
    _currentYear = value;
    notifyListeners();
  }

  int? get currentYear => _currentYear;

  set currentMonth(int? value) {
    _currentMonth = value;
    notifyListeners();
  }

  int? get currentMonth => _currentMonth;
}
