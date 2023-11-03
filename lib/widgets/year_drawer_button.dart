import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/date_repository.dart';
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

  void activeYear() {
    setState(() {
      isYearActive = !isYearActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<DateRepository>(context, listen: false);
    final int currentYear =
        Provider.of<DateRepository>(context, listen: false).currentYear!;
    final int currentMonth =
        Provider.of<DateRepository>(context, listen: false).currentMonth!;

    List<Month> months = [];

    return FutureBuilder(
      future: coreDatabase.getMonthsFromYear(
          year: widget.year.year, context: context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          months = snapshot.data!;
        }
        return Column(
          children: [
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: months.isNotEmpty
                  ? Icon(
                      isYearActive
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 32,
                    )
                  : null,
              title: Text(
                '${widget.year.year}',
                style: const TextStyle(fontSize: 15),
              ),
              trailing: Text(widget.year.year == currentYear ? 'Current' : ''),
              onTap: () {
                if (months.isEmpty) {
                  dateProvider.selectedMonth = null;
                  dateProvider.selectedYear = null;
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
                        leading: month.monthNumber == dateProvider.selectedMonth
                            ? const Icon(
                                Icons.square_rounded,
                                size: 14,
                              )
                            : null,
                        title: Text(
                            '${month.monthName!} (${month.monthNumber == currentMonth ? "current" : ""})'),
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
