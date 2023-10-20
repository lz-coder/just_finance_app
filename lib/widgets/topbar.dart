import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/config_page.dart';
import 'package:just_finance_app/widgets/topbar_tabbar.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double totalValue;
  final double incommingValue;
  final double dispenseValue;
  final Function changeTabCallback;

  const TopBar({
    super.key,
    required this.totalValue,
    required this.incommingValue,
    required this.dispenseValue,
    required this.changeTabCallback,
  });

  @override
  final Size preferredSize = const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.monetization_on_outlined,
            size: 32,
            color: totalValue >= 0 ? Colors.green : Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 20),
            child: Text('$totalValue'),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ConfigPage())),
          child: const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.settings,
              size: 34,
            ),
          ),
        )
      ],
      bottom: TopbarTabBar(changeTabCallback: changeTabCallback),
    );
  }
}
