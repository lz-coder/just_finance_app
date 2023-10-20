import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
