import 'package:flutter/material.dart';
import 'package:just_finance_app/widgets/main_chart.dart';
import 'package:just_finance_app/widgets/year_month_chart.dart';

class HomePageGraphics extends StatelessWidget {
  const HomePageGraphics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const MainChart(),
        YearMonthChart(context: context),
      ],
    );
  }
}
