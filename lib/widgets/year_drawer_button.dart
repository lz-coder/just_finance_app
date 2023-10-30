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
  bool isActive = false;

  void active() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentYear = Provider.of<DateRepository>(context).currentYear!;
    final int currentMonth = Provider.of<DateRepository>(context).currentMonth!;
    return Column(
      children: [
        ListTile(
          leading: Icon(
            isActive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 28,
          ),
          title: Text(
            '${widget.year.year}',
            style: const TextStyle(fontSize: 15),
          ),
          onTap: () => active(),
        ),
        if (isActive)
          FutureBuilder(
            future: coreDatabase.getMonthsFromYear(
                year: widget.year.year, context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Month> months = snapshot.data!;
                return Align(
                  child: SizedBox(
                    width: 200,
                    height: 60 * months.length.toDouble(),
                    child: ListView.builder(
                      itemCount: months.length,
                      itemBuilder: (context, index) {
                        final currentMonth = months[index];
                        return ListTile(
                          leading:
                              currentMonth.monthNumber == DateTime.now().month
                                  ? const Icon(Icons.arrow_right)
                                  : null,
                          title: Text(currentMonth.monthName!),
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
