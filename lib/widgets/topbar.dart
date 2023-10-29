import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/config_page.dart';
import 'package:just_finance_app/widgets/topbar_tabbar.dart';
import 'package:just_finance_app/widgets/wallet_value_counter.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Function changeTabCallback;

  const TopBar({
    super.key,
    required this.changeTabCallback,
  });

  @override
  final Size preferredSize = const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const WalletValueCounter(),
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
