import 'package:flutter/material.dart';

class TopbarTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Function changeTabCallback;

  @override
  final Size preferredSize = const Size.fromHeight(32);
  const TopbarTabBar({
    super.key,
    required this.changeTabCallback,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
        isScrollable: false,
        onTap: (value) {
          switch (value) {
            case 0:
              changeTabCallback(true);
              break;
            case 1:
              changeTabCallback(false);
              break;
          }
        },
        tabs: const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.pie_chart)),
        ]);
  }
}
