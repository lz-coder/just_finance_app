import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/categorie.dart';
import 'package:just_finance_app/src/config.dart';

final coreDatabase = CoreDatabase();

class AppInit {
  void initializeDefaultCategories(BuildContext context) {
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
          name: AppLocalizations.of(context)!.defaultCategoriePersonalExpenses,
          type: CategorieTypes.dispense),
    );
  }

  void initializeLocaleConfigs(BuildContext context) async {
    final systemLocale =
        '${Localizations.localeOf(context).languageCode}_${Localizations.localeOf(context).countryCode}';
    final Config localeConfig = Config(
      id: 0,
      name: 'locale_config',
      value: systemLocale,
    );
    await coreDatabase.insertConfig(localeConfig);
  }
}
