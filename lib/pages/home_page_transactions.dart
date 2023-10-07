import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/transaction_card.dart';

final transactionsDb = TransactionsDatabase();

class HomePageTransactions extends StatelessWidget {
  final Future futureBuilder;
  final Function dismissCallback;

  const HomePageTransactions({
    super.key,
    required this.futureBuilder,
    required this.dismissCallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: transactionsDb.transactionsList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final transaction = snapshot.data![index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await dismissCallback(transaction);
                },
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                child: TransactionCard(transaction: transaction),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
