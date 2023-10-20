import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';

final coreDatabase = CoreDatabase();

class TransactionCard extends StatelessWidget {
  final TransactionInfo transaction;
  final Function dialogCallback;

  const TransactionCard({
    super.key,
    required this.transaction,
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
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(transaction.title),
        subtitle: Text(transaction.categorieName),
        trailing: Text(
          '\$ ${transaction.value}',
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () => dialogCallback(
          transaction.incomming == 0 ? false : true,
          transaction,
        ),
      ),
    );
  }
}
