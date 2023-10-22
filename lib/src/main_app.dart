import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/config_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/pages/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_finance_app/src/app_init.dart';
import 'package:just_finance_app/src/config.dart';
import 'package:provider/provider.dart';

final coreDatabase = CoreDatabase();
final appInit = AppInit();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Config? _supportLanguageConfig;

  Future<void> _loadConfig() async {
    final config = await coreDatabase.getConfig('locale_config');
    setState(() {
      _supportLanguageConfig = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_supportLanguageConfig == null) {
      _loadConfig();
    }
    return Consumer<ConfigRepository>(builder: (context, value, child) {
      if (_supportLanguageConfig != null &&
          value.currentLocale != null &&
          value.currentLocale != _supportLanguageConfig!.toLocale()) {
        _loadConfig();
        _supportLanguageConfig = null;
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Just Finance',
        theme: ThemeData(colorScheme: const ColorScheme.dark()),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _supportLanguageConfig != null
            ? _supportLanguageConfig!.toLocale()
            : Provider.of<ConfigRepository>(context).currentLocale,
        home: DefaultTabController(
          length: 2,
          child: Builder(builder: (context) {
            appInit.initializeDefaultCategories(context);
            appInit.initializeLocaleConfigs(context);
            return const HomePage();
          }),
        ),
      );
    });
  }
}
