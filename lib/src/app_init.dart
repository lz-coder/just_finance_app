import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/category.dart';
import 'package:just_finance_app/src/config.dart';

final coreDatabase = CoreDatabase();

class AppInit {
  void initializeDefaultCategories(BuildContext context) {
    coreDatabase.insertCategory(
      Category(
          id: 0,
          name: AppLocalizations.of(context)!.defaultCategorieSalary,
          type: CategoryTypes.income),
    );
    coreDatabase.insertCategory(
      Category(
          id: 1,
          name: AppLocalizations.of(context)!.defaultCategorieExtra,
          type: CategoryTypes.income),
    );
    coreDatabase.insertCategory(
      Category(
          id: 2,
          name: AppLocalizations.of(context)!.defaultCategorieBills,
          type: CategoryTypes.expense),
    );
    coreDatabase.insertCategory(
      Category(
          id: 3,
          name: AppLocalizations.of(context)!.defaultCategoriePersonalExpenses,
          type: CategoryTypes.expense),
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
