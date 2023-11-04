import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/category_repository.dart';
import 'package:just_finance_app/Repository/date_repository.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/month.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/transaction_card.dart';
import 'package:provider/provider.dart';

final coreDatabase = CoreDatabase();

class HomePageTransactions extends StatelessWidget {
  final Function updateDialogCallback;

  const HomePageTransactions({
    super.key,
    required this.updateDialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear =
        Provider.of<DateRepository>(context, listen: false).currentYear;
    final currentMonth =
        Provider.of<DateRepository>(context, listen: false).currentMonth;
    final selectedYear = Provider.of<DateRepository>(context).selectedYear;
    final selectedMonth = Provider.of<DateRepository>(context).selectedMonth;
    final currentMonthText =
        Month(monthNumber: selectedMonth ?? currentMonth!, context: context)
            .monthName;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 4, bottom: 10),
          //color: const Color.fromARGB(225, 26, 26, 26),
          decoration: const BoxDecoration(
            color: Color.fromARGB(225, 26, 26, 26),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text('$currentMonthText'),
                  const SizedBox(width: 10),
                  Text('${selectedYear ?? currentYear}'),
                ],
              ),
              SizedBox(
                width: 120,
                child: FutureBuilder(
                  future: coreDatabase.getTransactionsByYearMonth(
                      year: selectedYear ?? currentYear!,
                      month: selectedMonth ?? currentMonth!),
                  builder: (context, snapshot) {
                    final transactions = snapshot.data;
                    int incomeCounter = 0;
                    int expenseCounter = 0;
                    if (transactions != null) {
                      for (TransactionInfo transaction in transactions) {
                        if (transaction.income == 1) {
                          incomeCounter += 1;
                        } else {
                          expenseCounter += 1;
                        }
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                            ),
                            Text('$incomeCounter'),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red),
                            Text('$expenseCounter')
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<CategoryRepository>(
            builder: (context, value, child) {
              return FutureBuilder(
                future: coreDatabase.getTransactionsByYearMonth(
                  year: selectedYear ?? currentYear!,
                  month: selectedMonth ?? currentMonth!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 90, top: 5, left: 5, right: 5),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // reverse the order on the list
                        final transaction =
                            snapshot.data![snapshot.data!.length - index - 1];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await Provider.of<WalletRepository>(context,
                                    listen: false)
                                .removeTransaction(transaction);
                            snapshot.data!.remove(transaction);
                          },
                          background: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(199, 244, 67, 54),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 46,
                              ),
                            ),
                          ),
                          child: TransactionCard(
                            transaction: transaction,
                            dialogCallback: updateDialogCallback,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Não há movimentações!'));
                  }
                },
              );
            },
          ),
        )
      ],
    );
  }
}
