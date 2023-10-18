import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/widgets/transaction_card.dart';

final coreDatabase = CoreDatabase();

class HomePageTransactions extends StatelessWidget {
  final Function dismissCallback;
  final Function transactionUpdater;
  final Function updateDialogCallback;
  final _viewCount = 30;

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
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: snapshot.data!.length >= _viewCount
                ? _viewCount
                : snapshot.data!.length,
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
                  updater: transactionUpdater,
                  dialogCallback: updateDialogCallback,
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
