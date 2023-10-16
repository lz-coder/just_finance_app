import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/widgets/transaction_card.dart';

final coreDatabase = CoreDatabase();

class HomePageTransactions extends StatelessWidget {
  final Function dismissCallback;
  final Function transactionUpdater;
  final Function updateDialogCallback;

  const HomePageTransactions({
    super.key,
    required this.dismissCallback,
    required this.transactionUpdater,
    required this.updateDialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: coreDatabase.transactionsList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // reverse the order on the list
              final transaction =
                  snapshot.data![snapshot.data!.length - index - 1];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await dismissCallback(transaction);
                  snapshot.data!.remove(transaction);
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
                      size: 46,
                    ),
                  ),
                ),
                child: TransactionCard(
                  transaction: transaction,
                  updater: transactionUpdater,
                  dialogCallback: updateDialogCallback,
                ),
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
