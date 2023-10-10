import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';

var transactionsDb = TransactionsDatabase();

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
  final valueController = TextEditingController();
  final titleController = TextEditingController();

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.incomming
              ? const Color.fromARGB(155, 39, 80, 51)
              : const Color.fromARGB(155, 80, 47, 39),
        ),
        child: Column(
          children: [
            const Text(
              'New Transaction',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(label: Text('Title')),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: valueController,
              decoration: const InputDecoration(label: Text('Value')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      late int lastTransactionId;
                      final transactionsList =
                          await transactionsDb.transactionsList();
                      if (transactionsList.isNotEmpty) {
                        lastTransactionId = transactionsList.last.id + 1;
                      } else {
                        lastTransactionId = 0;
                      }
                      final transaction = TransactionInfo(
                        id: lastTransactionId,
                        title: titleController.text.isNotEmpty
                            ? titleController.text
                            : 'New transaction',
                        incomming: widget.incomming ? 1 : 0,
                        value: valueController.text.isNotEmpty
                            ? double.parse(valueController.text)
                            : 1,
                      );
                      await widget.insertCallback(transaction);
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (err) {
                      debugPrint(err.toString());
                    }
                  },
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
