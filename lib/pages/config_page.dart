import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_finance_app/Repository/config_repository.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:provider/provider.dart';

final coreDatabase = CoreDatabase();

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final List<Map<String, dynamic>> _localesMap = [
    {
      "code": "en",
      "country": null,
      "label": "English",
    },
    {
      "code": "pt",
      "country": "BR",
      "label": "Português Brasil",
    },
    {
      "code": "pt",
      "country": null,
      "label": "Português Portugal",
    }
  ];

  final configController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<Locale>> localesEntries = [];
    final Locale currentLocale = Localizations.localeOf(context);

    for (Locale locale in AppLocalizations.supportedLocales) {
      for (final localeInMap in _localesMap) {
        if (locale.languageCode == localeInMap['code'] &&
            locale.countryCode == localeInMap['country']) {
          localesEntries.add(
            DropdownMenuEntry(
              value: locale,
              label: localeInMap['label']!,
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.configPageTitle),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.info,
              size: 32,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.configLanguageLabel,
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                DropdownMenu<Locale>(
                  controller: configController,
                  dropdownMenuEntries: localesEntries,
                  initialSelection: currentLocale,
                  onSelected: (value) {
                    Provider.of<ConfigRepository>(context, listen: false)
                        .changeCurrentLocale(value);
                    //await coreDatabase.updateConfig('locale_config',
                    //'${value!.languageCode}_${value.countryCode}');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
