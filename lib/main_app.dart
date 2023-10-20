import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_finance_app/src/categorie.dart';
import 'package:just_finance_app/db/database.dart';

final coreDatabase = CoreDatabase();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Just Finance',
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          coreDatabase.insertCategorie(
            Categorie(
                id: 0,
                name: AppLocalizations.of(context)!.defaultCategorieSalary,
                type: CategorieTypes.incomming),
          );
          coreDatabase.insertCategorie(
            Categorie(
                id: 1,
                name: AppLocalizations.of(context)!.defaultCategorieExtra,
                type: CategorieTypes.incomming),
          );
          coreDatabase.insertCategorie(
            Categorie(
                id: 2,
                name: AppLocalizations.of(context)!.defaultCategorieBills,
                type: CategorieTypes.dispense),
          );
          coreDatabase.insertCategorie(
            Categorie(
                id: 3,
                name: AppLocalizations.of(context)!
                    .defaultCategoriePersonalExpenses,
                type: CategorieTypes.dispense),
          );

          return const HomePage();
        }),
      ),
    );
  }
}
