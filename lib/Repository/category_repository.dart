import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/category.dart';

final coreDatabase = CoreDatabase();

class CategoryRepository extends ChangeNotifier {
  Category? deletedCategory;
  Future<void> insertCategory(Category category) async {
    await coreDatabase.insertCategory(category);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await coreDatabase.updateCategory(category);
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await coreDatabase.deleteCategory(category);
    deletedCategory = category;
    notifyListeners();
  }
}
