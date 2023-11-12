import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/src/transaction_info.dart';

final CoreDatabase coreDatabase = CoreDatabase();

class YearMonthChart extends StatelessWidget {
  const YearMonthChart({super.key, required this.context});
  final Color _line1Color = Colors.green;
  final Color _line2Color = Colors.red;
  final BuildContext context;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

    String text;
    switch (value.toInt()) {
      case 0:
        text =
            AppLocalizations.of(context)!.calendarMonthJanuary.substring(0, 3);
        break;
      case 1:
        text =
            AppLocalizations.of(context)!.calendarMonthFebruary.substring(0, 3);
        break;
      case 2:
        text = AppLocalizations.of(context)!.calendarMonthMarch.substring(0, 3);
        break;
      case 3:
        text = AppLocalizations.of(context)!.calendarMonthApril.substring(0, 3);
        break;
      case 4:
        text = AppLocalizations.of(context)!.calendarMonthMay.substring(0, 3);
        break;
      case 5:
        text = AppLocalizations.of(context)!.calendarMonthJune.substring(0, 3);
        break;
      case 6:
        text = AppLocalizations.of(context)!.calendarMonthJuly.substring(0, 3);
        break;
      case 7:
        text =
            AppLocalizations.of(context)!.calendarMonthAugust.substring(0, 3);
        break;
      case 8:
        text = AppLocalizations.of(context)!
            .calendarMonthSeptember
            .substring(0, 3);
        break;
      case 9:
        text =
            AppLocalizations.of(context)!.calendarMonthOctober.substring(0, 3);
        break;
      case 10:
        text =
            AppLocalizations.of(context)!.calendarMonthNovember.substring(0, 3);
        break;
      case 11:
        text =
            AppLocalizations.of(context)!.calendarMonthDecember.substring(0, 3);
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    return SideTitleWidget(
      fitInside: SideTitleFitInsideData(
          enabled: true,
          axisPosition: meta.axisPosition,
          parentAxisSize: meta.parentAxisSize,
          distanceFromEdge: 0),
      axisSide: meta.axisSide,
      child: Text(
        '\$ $value',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<({double income, double expense})>> getMonthsValue() async {
      final List<({double income, double expense})> monthsValues = [];

      for (int i = 1; i <= 12; i++) {
        double incomeValue = 0;
        double expenseValue = 0;
        final List<TransactionInfo>? monthTransactions = await coreDatabase
            .getTransactionsByYearMonth(year: DateTime.now().year, month: i);
        if (monthTransactions != null) {
          for (final transaction in monthTransactions) {
            if (transaction.income == 1) {
              incomeValue += transaction.value;
            } else {
              expenseValue += transaction.value;
            }
          }
        }
        monthsValues.add((income: incomeValue, expense: expenseValue));
      }
      return monthsValues;
    }

    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 30,
          top: 10,
          bottom: 0,
        ),
        child: FutureBuilder(
            future: getMonthsValue(),
            builder: (context, snapshot) {
              return LineChart(LineChartData(
                lineTouchData: const LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Color.fromARGB(255, 77, 76, 76))),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, snapshot.data?[0].income ?? 0),
                      FlSpot(1, snapshot.data?[1].income ?? 0),
                      FlSpot(2, snapshot.data?[2].income ?? 0),
                      FlSpot(3, snapshot.data?[3].income ?? 0),
                      FlSpot(4, snapshot.data?[4].income ?? 0),
                      FlSpot(5, snapshot.data?[5].income ?? 0),
                      FlSpot(6, snapshot.data?[6].income ?? 0),
                      FlSpot(7, snapshot.data?[7].income ?? 0),
                      FlSpot(8, snapshot.data?[8].income ?? 0),
                      FlSpot(9, snapshot.data?[9].income ?? 0),
                      FlSpot(10, snapshot.data?[10].income ?? 0),
                      FlSpot(11, snapshot.data?[11].income ?? 0),
                    ],
                    isCurved: false,
                    barWidth: 2,
                    color: _line1Color,
                    dotData: const FlDotData(
                      show: true,
                    ),
                  ),
                  LineChartBarData(
                    spots: [
                      FlSpot(0, snapshot.data?[0].expense ?? 0),
                      FlSpot(1, snapshot.data?[1].expense ?? 0),
                      FlSpot(2, snapshot.data?[2].expense ?? 0),
                      FlSpot(3, snapshot.data?[3].expense ?? 0),
                      FlSpot(4, snapshot.data?[4].expense ?? 0),
                      FlSpot(5, snapshot.data?[5].expense ?? 0),
                      FlSpot(6, snapshot.data?[6].expense ?? 0),
                      FlSpot(7, snapshot.data?[7].expense ?? 0),
                      FlSpot(8, snapshot.data?[8].expense ?? 0),
                      FlSpot(9, snapshot.data?[9].expense ?? 0),
                      FlSpot(10, snapshot.data?[10].expense ?? 0),
                      FlSpot(11, snapshot.data?[11].expense ?? 0),
                    ],
                    isCurved: false,
                    barWidth: 2,
                    color: _line2Color,
                    dotData: const FlDotData(
                      show: true,
                    ),
                  ),
                ],
                minY: 0,
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      getTitlesWidget: leftTitleWidgets,
                      interval: 1,
                      reservedSize: 42,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(
                  show: false,
                  drawVerticalLine: true,
                  drawHorizontalLine: false,
                  horizontalInterval: 1,
                ),
              ));
            }),
      ),
    );
  }
}
