import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.editCallback,
    required this.deleteCallback,
  });

  final Category category;

  final Function({Category category, bool update}) editCallback;
  final Function({required Category category}) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .8,
            color: Color.fromARGB(255, 99, 99, 99),
          ),
        ),
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        style: ListTileStyle.list,
        title: Text(
          category.name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          category.type == CategoryTypes.income
              ? AppLocalizations.of(context)!.transactionIncome
              : AppLocalizations.of(context)!.transactionExpense,
          style: TextStyle(
            color: category.type == CategoryTypes.expense
                ? Colors.red
                : Colors.green,
            fontSize: 16,
          ),
        ),
        trailing: SizedBox(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: category.id <= 3
                    ? null
                    : () => deleteCallback(category: category),
                icon: Icon(
                  Icons.delete_forever,
                  color: category.id > 3 ? Colors.red : Colors.grey,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  editCallback(category: category, update: true);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
