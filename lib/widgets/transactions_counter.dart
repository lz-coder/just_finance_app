import 'package:flutter/material.dart';

class TransactionsCounter extends StatelessWidget {
  const TransactionsCounter(
      {super.key, required this.income, required this.counter});

  final bool income;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          income ? Icons.arrow_upward : Icons.arrow_downward,
          color: income ? Colors.green : Colors.red,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('$counter'),
        ),
      ],
    );
  }
}
