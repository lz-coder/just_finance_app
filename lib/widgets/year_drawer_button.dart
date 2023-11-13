import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/repository/date_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/month.dart';
import 'package:just_finance_app/src/year.dart';
import 'package:provider/provider.dart';

final coreDatabase = CoreDatabase();

class YearDrawerButton extends StatefulWidget {
  const YearDrawerButton({super.key, required this.year});

  final Year year;

  @override
  State<YearDrawerButton> createState() => _YearDrawerButtonState();
}

class _YearDrawerButtonState extends State<YearDrawerButton> {
  bool isYearActive = false;
  Future<List<Month>?>? _monthsFromYear;
  bool isSelected = false;

  void activeYear() {
    setState(() {
      isYearActive = !isYearActive;
    });
  }

  @override
  void initState() {
    super.initState();
    _monthsFromYear = coreDatabase.getMonthsFromYear(
        year: widget.year.year, context: context);
    if (widget.year.year == DateTime.now().year) {
      isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<DateRepository>(context, listen: false);
    final int currentYear =
        Provider.of<DateRepository>(context, listen: false).currentYear!;
    final int currentMonth =
        Provider.of<DateRepository>(context, listen: false).currentMonth!;
    final int? selectedYear = Provider.of<DateRepository>(context).selectedYear;
    List<Month> months = [];
    if (selectedYear == widget.year.year) {
      isSelected = true;
    }

    return FutureBuilder(
      future: _monthsFromYear,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          months = snapshot.data!;
        }
        return Column(
          children: [
            ListTile(
              selected: isSelected,
              titleAlignment: ListTileTitleAlignment.center,
              leading: months.isNotEmpty
                  ? Icon(
                      isYearActive
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 32,
                    )
                  : const SizedBox(),
              title: Text(
                '${widget.year.year}',
                style: const TextStyle(fontSize: 15),
              ),
              trailing: Text(widget.year.year == currentYear
                  ? '${AppLocalizations.of(context)?.drawerButtonCurrentLabel}'
                  : ''),
              onTap: () {
                if (months.isEmpty) {
                  dateProvider.selectedMonth = null;
                  dateProvider.selectedYear = widget.year.year;
                  Navigator.pop(context);
                } else {
                  activeYear();
                }
              },
            ),
            if (isYearActive)
              Align(
                child: SizedBox(
                  width: 250,
                  height: 60 * months.length.toDouble(),
                  child: ListView.builder(
                    itemCount: months.length,
                    itemBuilder: (context, index) {
                      final month = months[index];
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: month.monthNumber ==
                                        dateProvider.selectedMonth &&
                                    selectedYear == widget.year.year ||
                                month.monthNumber ==
                                        dateProvider.currentMonth &&
                                    widget.year.year == dateProvider.currentYear
                            ? const Icon(
                                Icons.square_rounded,
                                size: 14,
                              )
                            : const SizedBox(),
                        title: Row(
                          children: [
                            Text(month.monthName!),
                            if (widget.year.year == dateProvider.currentYear &&
                                month.monthNumber == dateProvider.currentMonth)
                              const SizedBox(width: 20),
                            Text(
                                '(${AppLocalizations.of(context)?.drawerButtonCurrentLabel})')
                          ],
                        ),
                        onTap: () {
                          dateProvider.selectedMonth = month.monthNumber;
                          dateProvider.selectedYear = widget.year.year;
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
