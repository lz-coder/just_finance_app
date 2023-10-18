import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';

final coreDatabase = CoreDatabase();

class TransactionCard extends StatelessWidget {
  final TransactionInfo transaction;
  final Function updater;
  final Function dialogCallback;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.updater,
    required this.dialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: transaction.incomming == 0
            ? const Color.fromARGB(204, 117, 76, 76)
            : const Color.fromARGB(204, 83, 117, 76),
      ),
      child: ListTile(
        leading: Text('\$ ${transaction.value}'),
        title: Text(transaction.title),
        subtitle: Text(transaction.categorieName),
        trailing: GestureDetector(
          onTap: () => dialogCallback(
            updater,
            transaction.incomming == 0 ? false : true,
            transaction,
          ),
          child: SizedBox(
            height: 40,
            width: 42,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: const Color.fromARGB(141, 255, 255, 255),
              ),
              child: const Icon(
                Icons.edit,
                size: 28,
                color: Color.fromARGB(255, 153, 75, 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
