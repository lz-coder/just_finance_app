import 'package:flutter/material.dart';
import 'package:just_finance_app/src/transaction_info.dart';

class TransactionDialog extends StatefulWidget {
  final Function insertCallback;
  final bool incomming;

  const TransactionDialog({
    super.key,
    required this.insertCallback,
    required this.incomming,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  var value_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            const Text(
              'New Transaction',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: value_controller,
              decoration: const InputDecoration(label: Text('Value')),
            ),
            const ElevatedButton(
              onPressed: null,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
