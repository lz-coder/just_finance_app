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

    if (currentYear == widget.year.year) {
      isYearActive = true;
      //dateProvider.selectedYear = widget.year.year;
    }

    List<Month>? months;

    return Column(
      children: [
        ListTile(
          leading: Icon(
            isYearActive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 28,
          ),
          title: Text(
            '${widget.year.year}',
            style: const TextStyle(fontSize: 15),
          ),
          onTap: () {
            activeYear();
          },
        ),
        if (isYearActive)
          FutureBuilder(
            future: coreDatabase.getMonthsFromYear(
                year: widget.year.year, context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                months = snapshot.data!;
                return Align(
                  child: SizedBox(
                    width: 200,
                    height: 60 * months!.length.toDouble(),
                    child: ListView.builder(
                      itemCount: months!.length,
                      itemBuilder: (context, index) {
                        final month = months![index];
                        return ListTile(
                          leading: month.monthNumber == currentMonth
                              ? const Icon(Icons.arrow_right)
                              : null,
                          title: Text(month.monthName!),
                          onTap: () {
                            dateProvider.selectedMonth = month.monthNumber;
                            dateProvider.selectedYear = widget.year.year;
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
      ],
    );
  }
}
