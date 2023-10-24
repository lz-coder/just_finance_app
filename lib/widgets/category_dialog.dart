import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';

final coreDatabase = CoreDatabase();

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    super.key,
    this.category,
    required this.actionCallback,
  });

  final Category? category;
  final Function actionCallback;

  @override
  State<CategoryDialog> createState() => _CategorieDialogState();
}

class _CategorieDialogState extends State<CategoryDialog> {
  final _categorieNameController = TextEditingController();
  bool isIncomeChecked = true;
  bool? incomeCheckedSupport;

  @override
  Widget build(BuildContext context) {
    if (widget.category != null) {
      _categorieNameController.text = widget.category!.name;
      isIncomeChecked =
          incomeCheckedSupport ?? widget.category!.type == CategoryTypes.income
              ? true
              : false;
    }
    return Dialog(
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(widget.category == null
                ? AppLocalizations.of(context)!.categoriesDialogTitleNew
                : AppLocalizations.of(context)!.categoriesDialogTitleEdit),
            if (1 == 1)
              TextField(
                controller: _categorieNameController,
                decoration: InputDecoration(
                  label: Text(
                      AppLocalizations.of(context)!.categoriesDialogNameField),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: isIncomeChecked,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red,
                  onChanged: (value) {
                    if (widget.category != null && widget.category!.id > 3 ||
                        widget.category == null) {
                      setState(() {
                        if (widget.category != null) {
                          incomeCheckedSupport = value;
                        }
                        isIncomeChecked = value;
                      });
                    }
                  },
                ),
                Text(isIncomeChecked
                    ? AppLocalizations.of(context)!.categorieTypeIncome
                    : AppLocalizations.of(context)!.categorieTypeExpense),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    executor() async {
                      if (widget.category != null) {
                        widget.category!.name = _categorieNameController.text;
                        widget.category!.type = isIncomeChecked
                            ? CategoryTypes.income
                            : CategoryTypes.expense;
                        await widget.actionCallback(widget.category);
                      } else {
                        late int lastCategorieId;
                        final categoriesList =
                            await coreDatabase.categoriesList();
                        if (categoriesList.isNotEmpty) {
                          lastCategorieId = categoriesList.last.id + 1;
                        } else {
                          lastCategorieId = 0;
                        }
                        final category = Category(
                          id: lastCategorieId,
                          name: _categorieNameController.text,
                          type: isIncomeChecked
                              ? CategoryTypes.income
                              : CategoryTypes.expense,
                        );
                        await widget.actionCallback(category);
                      }
                    }

                    executor();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      AppLocalizations.of(context)!.transactionDialogAddLabel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
