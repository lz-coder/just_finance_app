import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/home_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Finance',
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      home: const DefaultTabController(
        length: 2,
        child: HomePage(),
      ),
    );
  }
}
