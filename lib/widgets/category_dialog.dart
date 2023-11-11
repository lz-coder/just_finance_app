import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/category_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';
import 'package:provider/provider.dart';

final coreDatabase = CoreDatabase();

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    super.key,
    this.category,
    this.isIncome,
  });

  final Category? category;
  final bool? isIncome;

  @override
  State<CategoryDialog> createState() => _CategorieDialogState();
}

class _CategorieDialogState extends State<CategoryDialog> {
  final _categorieNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void addCategory(Category category) {
      Provider.of<CategoryRepository>(context, listen: false)
          .insertCategory(category);
    }

    void updateCategory(Category category) {
      Provider.of<CategoryRepository>(context, listen: false)
          .updateCategory(category);
    }

    if (widget.category != null) {
      _categorieNameController.text = widget.category!.name;
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
            TextField(
              controller: _categorieNameController,
              decoration: InputDecoration(
                label: Text(
                    AppLocalizations.of(context)!.categoriesDialogNameField),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    void executor() async {
                      if (widget.category != null) {
                        widget.category!.name = _categorieNameController.text;
                        updateCategory(widget.category!);
                      } else {
                        late int lastCategorieId;
                        final List<Category>? categoriesList =
                            await coreDatabase.categoriesList();
                        if (categoriesList != null) {
                          lastCategorieId = categoriesList.last.id + 1;
                        } else {
                          lastCategorieId = 0;
                        }
                        final category = Category(
                          id: lastCategorieId,
                          name: _categorieNameController.text,
                          type: widget.isIncome!
                              ? CategoryTypes.income
                              : CategoryTypes.expense,
                        );
                        addCategory(category);
                      }
                    }

                    executor();
                    Navigator.of(context).pop();
                  },
                  child: Text(widget.category == null
                      ? AppLocalizations.of(context)!.transactionDialogAddLabel
                      : MaterialLocalizations.of(context).saveButtonLabel),
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
