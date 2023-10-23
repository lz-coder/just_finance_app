import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/categorie.dart';

class CategorieDialog extends StatefulWidget {
  const CategorieDialog({super.key, this.categorie});

  final Categorie? categorie;

  @override
  State<CategorieDialog> createState() => _CategorieDialogState();
}

class _CategorieDialogState extends State<CategorieDialog> {
  final _categorieNameController = TextEditingController();
  bool isIncomeChecked = true;

  @override
  Widget build(BuildContext context) {
    if (widget.categorie != null) {
      _categorieNameController.text = widget.categorie!.name;
      isIncomeChecked =
          widget.categorie!.type == CategorieTypes.incomming ? true : false;
    }
    return Dialog(
      child: Container(
        width: 400,
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(widget.categorie == null
                ? AppLocalizations.of(context)!.categoriesDialogTitleNew
                : AppLocalizations.of(context)!.categoriesDialogTitleEdit),
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
                    if (widget.categorie != null && widget.categorie!.id > 3 ||
                        widget.categorie == null) {
                      setState(() {
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
                  onPressed: null,
                  child: Text(
                      AppLocalizations.of(context)!.transactionDialogAddLabel),
                ),
                ElevatedButton(
                  onPressed: null,
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
