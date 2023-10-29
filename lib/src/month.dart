import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';

class Month {
  final int monthNumber;
  final BuildContext context;
  String? _monthName;

  Month({required this.monthNumber, required this.context}) {
    switch (monthNumber) {
      case 1:
        _monthName = AppLocalizations.of(context)!.calendarMonthJanuary;
        break;
      case 2:
        _monthName = AppLocalizations.of(context)!.calendarMonthFebruary;
        break;
      case 3:
        _monthName = AppLocalizations.of(context)!.calendarMonthMarch;
        break;
      case 4:
        _monthName = AppLocalizations.of(context)!.calendarMonthApril;
        break;
      case 5:
        _monthName = AppLocalizations.of(context)!.calendarMonthMay;
        break;
      case 6:
        _monthName = AppLocalizations.of(context)!.calendarMonthJune;
        break;
      case 7:
        _monthName = AppLocalizations.of(context)!.calendarMonthJuly;
        break;
      case 8:
        _monthName = AppLocalizations.of(context)!.calendarMonthAugust;
        break;
      case 9:
        _monthName = AppLocalizations.of(context)!.calendarMonthSeptember;
        break;
      case 10:
        _monthName = AppLocalizations.of(context)!.calendarMonthOctober;
        break;
      case 11:
        _monthName = AppLocalizations.of(context)!.calendarMonthNovember;
        break;
      case 12:
        _monthName = AppLocalizations.of(context)!.calendarMonthDecember;
        break;
      default:
        _monthName = "Invalid Month";
        break;
    }
  }

  String? get monthName => _monthName;
}
