import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/categorie.dart';
import 'package:just_finance_app/widgets/categorie_card.dart';
import 'package:just_finance_app/widgets/categorie_dialog.dart';

final coreDatabase = CoreDatabase();

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor({super.key});

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  void _showCategorieDialog({Categorie? categorie}) {
    showDialog(
      context: context,
      builder: (context) {
        return CategorieDialog(categorie: categorie);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(AppLocalizations.of(context)!.categoriesEditorTitle),
        actions: [
          IconButton(
            onPressed: () => _showCategorieDialog(),
            icon: const Icon(
              Icons.add_box,
              size: 42,
              color: Colors.green,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: coreDatabase.categoriesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CategorieCard(
                  categorie: snapshot.data![index],
                  editCallback: _showCategorieDialog,
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
