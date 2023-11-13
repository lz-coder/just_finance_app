import 'package:flutter/material.dart';

class DateRepository extends ChangeNotifier {
  int? _currentYear;
  int? _currentMonth;
  int? _selectedMonth;
  int? _selectedYear;

  void setCurrentYear(int? value, {bool notify = false}) {
    _currentYear = value;
    if (notify) notifyListeners();
  }

  int? get currentYear => _currentYear;

  void setCurrentMonth(int? value, {bool notify = false}) {
    _currentMonth = value;
    if (notify) notifyListeners();
  }

  int? get currentMonth => _currentMonth;

  set selectedYear(int? value) {
    _selectedYear = value;
    notifyListeners();
  }

  int? get selectedYear => _selectedYear;

  set selectedMonth(int? value) {
    _selectedMonth = value;
    notifyListeners();
  }

  int? get selectedMonth => _selectedMonth;
}
