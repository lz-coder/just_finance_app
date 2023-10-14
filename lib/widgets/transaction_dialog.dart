import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/categorie.dart';
import 'package:just_finance_app/src/transaction_info.dart';

var coreDatabase = CoreDatabase();

class TransactionDialog extends StatefulWidget {
  final Function insertCallback;
  final bool incomming;
  final TransactionInfo? transaction;

  const TransactionDialog({
    super.key,
    required this.insertCallback,
    required this.incomming,
    this.transaction,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final valueController = TextEditingController();
  final titleController = TextEditingController();
  final categoriesController = TextEditingController();
  Categorie? selectedCategorie;

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transaction != null) {
      valueController.text = widget.transaction!.value.toString();
      titleController.text = widget.transaction!.title;
    }
    return Dialog(
      child: Container(
        height: 280,
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.incomming
              ? const Color.fromARGB(155, 39, 80, 51)
              : const Color.fromARGB(155, 80, 47, 39),
        ),
        child: Column(
          children: [
            Text(
              widget.transaction != null
                  ? 'Edit Transaction'
                  : 'New Transaction',
              style: const TextStyle(fontSize: 18),
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
            FutureBuilder(
              future: widget.incomming
                  ? coreDatabase.incommingCategories()
                  : coreDatabase.dispenseCategories(),
              builder: (context, snapshot) {
                final List<DropdownMenuEntry<Categorie>> categorieEntries = [];
                if (snapshot.hasData) {
                  for (final categorie in snapshot.data!) {
                    categorieEntries.add(DropdownMenuEntry(
                        value: categorie, label: categorie.name));
                  }
                }
                return DropdownMenu<Categorie>(
                  initialSelection:
                      snapshot.data != null ? snapshot.data![0] : null,
                  controller: categoriesController,
                  label: const Text('Categorie'),
                  dropdownMenuEntries: categorieEntries,
                  onSelected: (Categorie? categorie) {
                    setState(() {
                      selectedCategorie = categorie;
                    });
                  },
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (widget.transaction == null) {
                        late int lastTransactionId;
                        final transactionsList =
                            await coreDatabase.transactionsList();
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
                      } else {
                        widget.transaction!.setTitle = titleController.text;
                        widget.transaction!.setValue =
                            double.parse(valueController.text);
                        await widget.insertCallback(widget.transaction);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (err) {
                      debugPrint('error: ${err.toString()}');
                    }
                  },
                  child: Text(widget.transaction == null ? 'Add' : 'update'),
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
