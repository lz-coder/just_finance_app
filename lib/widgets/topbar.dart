import 'package:flutter/material.dart';
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
      title: Row(children: [
        Icon(
          Icons.monetization_on_outlined,
          size: 32,
          color: totalValue >= 0 ? Colors.green : Colors.red,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text('$totalValue'),
        ),
      ]),
      actions: [
        Row(
          children: [
            const Icon(
              Icons.arrow_upward,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('$incommingValue'),
            ),
            const Icon(
              Icons.arrow_downward,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('$dispenseValue'),
            )
          ],
        )
      ],
      bottom: TopbarTabBar(changeTabCallback: changeTabCallback),
    );
  }
}
