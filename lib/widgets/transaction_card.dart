import 'package:flutter/material.dart';
import 'package:just_finance_app/src/transaction_info.dart';

class TransactionCard extends StatelessWidget {
  final TransactionInfo transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: transaction.incomming == 0
            ? Color.fromARGB(146, 180, 65, 65)
            : const Color.fromARGB(146, 71, 179, 85),
      ),
      child: ListTile(
        leading: Text('\$ ${transaction.value}'),
        title: Text(transaction.title),
      ),
    );
  }
}
