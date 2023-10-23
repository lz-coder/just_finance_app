import 'package:flutter/material.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/categorie.dart';

class CategorieCard extends StatelessWidget {
  const CategorieCard({
    super.key,
    required this.categorie,
    required this.editCallback,
  });

  final Categorie categorie;

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
          categorie.name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          categorie.type == CategorieTypes.incomming
              ? AppLocalizations.of(context)!.categorieTypeIncome
              : AppLocalizations.of(context)!.categorieTypeExpense,
          style: TextStyle(
            color: categorie.type == CategorieTypes.dispense
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
              if (categorie.id > 3)
                IconButton(
                  onPressed: () => '',
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: () => editCallback(categorie: categorie),
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
