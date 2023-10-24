import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.editCallback,
  });

  final Category category;

  ///TODO: implement callback functions
  final Function editCallback;
  //final Function deleteCallback;

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
              ? AppLocalizations.of(context)!.categorieTypeIncome
              : AppLocalizations.of(context)!.categorieTypeExpense,
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
              if (category.id > 3)
                IconButton(
                  onPressed: () => '',
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
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
