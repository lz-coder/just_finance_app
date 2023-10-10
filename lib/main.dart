import 'package:flutter/material.dart';
import 'package:just_finance_app/main_app.dart';

import 'db/database.dart';

final transactionsDb = TransactionsDatabase();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}
