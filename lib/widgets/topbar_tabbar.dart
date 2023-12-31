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
        indicatorColor: const Color.fromARGB(146, 83, 117, 76),
        indicatorWeight: 3,
        labelColor: const Color.fromARGB(255, 231, 227, 226),
        unselectedLabelColor: const Color.fromARGB(255, 89, 91, 94),
        enableFeedback: false,
        splashFactory: NoSplash.splashFactory,
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
          Tab(icon: Icon(Icons.money)),
          Tab(icon: Icon(Icons.pie_chart)),
        ]);
  }
}
