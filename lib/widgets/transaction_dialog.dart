import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/categorie.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:provider/provider.dart';

var coreDatabase = CoreDatabase();

class TransactionDialog extends StatefulWidget {
  final bool incomming;
  final TransactionInfo? transaction;

  const TransactionDialog({
    super.key,
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
  Categorie? preSelectedCategorie;

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
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.incomming
              ? const Color.fromARGB(155, 39, 80, 51)
              : const Color.fromARGB(155, 80, 47, 39),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  //selectedCategorie = snapshot.data![0];
                  for (final categorie in snapshot.data!) {
                    categorieEntries.add(DropdownMenuEntry(
                        value: categorie, label: categorie.name));
                  }

                  if (widget.transaction != null && selectedCategorie == null) {
                    for (Categorie categorie in snapshot.data!) {
                      if (categorie.id == widget.transaction!.categorie) {
                        selectedCategorie = categorie;
                      }
                    }
                  } else if (widget.transaction == null &&
                      selectedCategorie == null) {
                    preSelectedCategorie = snapshot.data![0];
                  }

                  return DropdownMenu<Categorie>(
                    width: 200,
                    initialSelection: preSelectedCategorie ?? selectedCategorie,
                    controller: categoriesController,
                    label: const Text('Categorie'),
                    dropdownMenuEntries: categorieEntries,
                    onSelected: (Categorie? categorie) {
                      setState(() {
                        selectedCategorie = categorie;
                      });
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
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
                          categorie: selectedCategorie != null
                              ? selectedCategorie!.id
                              : preSelectedCategorie!.id,
                          categorieName: selectedCategorie != null
                              ? selectedCategorie!.name
                              : preSelectedCategorie!.name,
                        );
                        // ignore: use_build_context_synchronously
                        await Provider.of<WalletRepository>(context,
                                listen: false)
                            .insertTransaction(transaction);
                      } else {
                        widget.transaction!.title = titleController.text;
                        widget.transaction!.value =
                            double.parse(valueController.text);
                        widget.transaction!.categorie = selectedCategorie!.id;
                        widget.transaction!.categorieName =
                            selectedCategorie!.name;
                        await Provider.of<WalletRepository>(context,
                                listen: false)
                            .updateTransaction(widget.transaction!);
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
