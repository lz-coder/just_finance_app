import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/category_repository.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/pages/categories_editor_page.dart';
import 'package:just_finance_app/src/category.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var coreDatabase = CoreDatabase();

class TransactionDialog extends StatefulWidget {
  final bool income;
  final TransactionInfo? transaction;

  const TransactionDialog({
    super.key,
    required this.income,
    this.transaction,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final valueController = TextEditingController();
  final titleController = TextEditingController();
  final categoriesController = TextEditingController();
  Category? selectedCategory;
  Category? preSelectedCategory;

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _updateDialog() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transaction != null) {
      valueController.text = widget.transaction!.value.toString();
      titleController.text = widget.transaction!.title;
    }

    return Consumer<CategoryRepository>(builder: (context, value, child) {
      return Dialog(
        child: Container(
          height: 400,
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: widget.income
                ? const Color.fromARGB(155, 39, 80, 51)
                : const Color.fromARGB(155, 80, 47, 39),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.transaction != null
                    ? AppLocalizations.of(context)!.transactionCardEditing
                    : AppLocalizations.of(context)!.transactionCardNew,
                style: const TextStyle(fontSize: 18),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!
                        .transactionDialogTitleLabel)),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: valueController,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!
                        .transactionDialogValueLabel)),
              ),
              FutureBuilder(
                future: widget.income
                    ? coreDatabase.incomeCategories()
                    : coreDatabase.expenseCategories(),
                builder: (context, snapshot) {
                  final List<DropdownMenuEntry<Category>> categoryEntries = [];
                  if (snapshot.hasData) {
                    //selectedCategorie = snapshot.data![0];
                    for (final categorie in snapshot.data!) {
                      categoryEntries.add(DropdownMenuEntry(
                          value: categorie, label: categorie.name));
                    }

                    if (widget.transaction != null &&
                        selectedCategory == null) {
                      for (Category category in snapshot.data!) {
                        if (category.id == widget.transaction!.category) {
                          selectedCategory = category;
                        }
                      }
                    } else if (widget.transaction == null &&
                        selectedCategory == null) {
                      preSelectedCategory = snapshot.data![0];
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownMenu<Category>(
                          width: 220,
                          initialSelection:
                              preSelectedCategory ?? selectedCategory,
                          controller: categoriesController,
                          label: Text(AppLocalizations.of(context)!
                              .transactionDialogCategorieLabel),
                          dropdownMenuEntries: categoryEntries,
                          onSelected: (Category? categorie) {
                            selectedCategory = categorie;
                          },
                        ),
                        SizedBox(
                          width: 64,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesEditor()),
                            ),
                            child: const Icon(Icons.edit, size: 28),
                          ),
                        )
                      ],
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
                                // ignore: use_build_context_synchronously
                                : AppLocalizations.of(context)!
                                    .transactionCardNew,
                            income: widget.income ? 1 : 0,
                            value: valueController.text.isNotEmpty
                                ? double.parse(valueController.text)
                                : 1,
                            category: selectedCategory != null
                                ? selectedCategory!.id
                                : preSelectedCategory!.id,
                            categoryName: selectedCategory != null
                                ? selectedCategory!.name
                                : preSelectedCategory!.name,
                          );
                          // ignore: use_build_context_synchronously
                          await Provider.of<WalletRepository>(context,
                                  listen: false)
                              .insertTransaction(transaction);
                        } else {
                          widget.transaction!.title = titleController.text;
                          widget.transaction!.value =
                              double.parse(valueController.text);
                          widget.transaction!.category = selectedCategory!.id;
                          widget.transaction!.categoryName =
                              selectedCategory!.name;
                          await Provider.of<WalletRepository>(context,
                                  listen: false)
                              .updateTransaction(widget.transaction!);
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      } catch (err) {
                        debugPrint('error: ${err.toString()}');
                      }
                    },
                    child: Text(widget.transaction == null
                        ? AppLocalizations.of(context)!
                            .transactionDialogAddLabel
                        : MaterialLocalizations.of(context).saveButtonLabel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
