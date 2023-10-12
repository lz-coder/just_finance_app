import 'package:flutter/material.dart';
import 'package:just_finance_app/main_app.dart';
import 'package:just_finance_app/src/categorie.dart';

import 'db/database.dart';

final coreDatabase = CoreDatabase();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  coreDatabase.insertCategorie(
      Categorie(id: 0, name: 'Salário', type: CategorieTypes.incomming));
  coreDatabase.insertCategorie(
      Categorie(id: 1, name: 'Extra', type: CategorieTypes.incomming));
  var categories = await coreDatabase.incommingCategories();
  print(categories);

  runApp(const MainApp());
}
