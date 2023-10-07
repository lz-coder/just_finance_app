import 'package:flutter/material.dart';
import 'package:just_finance_app/widgets/topbar_tabbar.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double totalValue;
  final Function changeTabCallback;

  const TopBar({
    super.key,
    required this.totalValue,
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
      actions: const [
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.settings,
              size: 34,
            )),
      ],
      bottom: TopbarTabBar(changeTabCallback: changeTabCallback),
    );
  }
}
