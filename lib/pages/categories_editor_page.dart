import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';
import 'package:just_finance_app/widgets/category_card.dart';
import 'package:just_finance_app/widgets/category_dialog.dart';

final coreDatabase = CoreDatabase();

class CategoriesEditor extends StatefulWidget {
  const CategoriesEditor({super.key});

  @override
  State<CategoriesEditor> createState() => _CategoriesEditorState();
}

class _CategoriesEditorState extends State<CategoriesEditor> {
  void _showCategoryDialog({Category? category, bool update = false}) {
    showDialog(
      context: context,
      builder: (context) {
        late Function action;
        if (update) {
          action = _updateCategory;
        } else {
          action = _insertCategory;
        }
        return CategoryDialog(
          category: category,
          actionCallback: action,
        );
      },
    );
  }

  Future<void> _updateCategory(Category category) async {
    await coreDatabase.updateCategory(category);
    setState(() {});
  }

  Future<void> _insertCategory(Category category) async {
    await coreDatabase.insertCategory(category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(AppLocalizations.of(context)!.categoriesEditorTitle),
        actions: [
          IconButton(
            onPressed: () => _showCategoryDialog(),
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
                return CategoryCard(
                  category: snapshot.data![index],
                  editCallback: _showCategoryDialog,
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
