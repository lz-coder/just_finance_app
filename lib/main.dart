import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/config_repository.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/main_app.dart';
import 'package:provider/provider.dart';

import 'db/database.dart';

final coreDatabase = CoreDatabase();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WalletRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigRepository(),
        )
      ],
      child: const MainApp(),
    ),
  );
}
