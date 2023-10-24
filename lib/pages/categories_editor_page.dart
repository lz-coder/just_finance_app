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
  Color _tabIndicatorColor = const Color.fromARGB(204, 83, 117, 76);
  Color _buttonColor = const Color.fromARGB(204, 115, 221, 94);
  bool _isIncome = true;

  void _changeTab({
    required Color indicatorColor,
    required Color buttonColor,
    required bool isIncome,
  }) {
    setState(() {
      _tabIndicatorColor = indicatorColor;
      _buttonColor = buttonColor;
      _isIncome = isIncome;
    });
  }

  void _showCategoryDialog(
      {Category? category, bool update = false, bool? isIncome}) {
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
          isIncome: isIncome,
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
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
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
            bottom: TabBar(
              isScrollable: false,
              onTap: (i) {
                switch (i) {
                  case 0:
                    _changeTab(
                      indicatorColor: const Color.fromARGB(204, 83, 117, 76),
                      buttonColor: const Color.fromARGB(204, 115, 221, 94),
                      isIncome: true,
                    );
                    break;
                  case 1:
                    _changeTab(
                      indicatorColor: const Color.fromARGB(204, 117, 76, 76),
                      buttonColor: const Color.fromARGB(204, 221, 94, 94),
                      isIncome: false,
                    );
                }
              },
              indicatorColor: _tabIndicatorColor,
              indicatorWeight: 3,
              labelColor: const Color.fromARGB(255, 231, 227, 226),
              unselectedLabelColor: const Color.fromARGB(255, 89, 91, 94),
              enableFeedback: false,
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.categorieTypeIncome),
                Tab(text: AppLocalizations.of(context)!.categorieTypeExpense),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: coreDatabase.incomeCategories(),
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
              FutureBuilder(
                future: coreDatabase.expenseCategories(),
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _buttonColor,
            onPressed: () => _showCategoryDialog(isIncome: _isIncome),
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}
