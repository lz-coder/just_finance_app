import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/l10n/app_localizations.dart';
import 'package:just_finance_app/repository/date_repository.dart';
import 'package:just_finance_app/resources/app_colors.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/chart_indicator.dart';
import 'package:provider/provider.dart';

final CoreDatabase coreDatabase = CoreDatabase();

class MainChart extends StatefulWidget {
  const MainChart({super.key});

  @override
  State<MainChart> createState() => _MainChartState();
}

class _MainChartState extends State<MainChart> {
  final Color _incomeColor = AppColors.incomeChartColor;
  final Color _expenseColor = AppColors.expenseChartColor;
  final _chartTitleStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  Future<({double income, double expense})> getYearValues(
      {required int year}) async {
    final List<TransactionInfo>? transactions =
        await coreDatabase.getTransactionsByYear(year: year);
    double incomeValue = 0;
    double expenseValue = 0;
    if (transactions != null) {
      for (final transaction in transactions) {
        if (transaction.income == 1) {
          incomeValue += transaction.value;
        } else {
          expenseValue += transaction.value;
        }
      }
    }
    return (income: incomeValue, expense: expenseValue);
  }

  @override
  Widget build(BuildContext context) {
    final int? selectedYear =
        Provider.of<DateRepository>(context, listen: false).selectedYear;
    final int? currentYear =
        Provider.of<DateRepository>(context, listen: false).currentYear;
    return FutureBuilder(
      future: getYearValues(year: selectedYear ?? currentYear!),
      builder: (context, snapshot) {
        List<PieChartSectionData> chartSections() {
          return List.generate(2, (i) {
            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: _incomeColor,
                  value: snapshot.data?.income ?? 0,
                  titleStyle: _chartTitleStyle,
                  radius: 100,
                );
              case 1:
                return PieChartSectionData(
                  color: _expenseColor,
                  value: snapshot.data?.expense ?? 0,
                  titleStyle: _chartTitleStyle,
                  radius: 100,
                );
              default:
                throw Exception('Oh no');
            }
          });
        }

        return AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChartIndicator(
                      color: _incomeColor,
                      text: AppLocalizations.of(context)!.transactionIncome),
                  ChartIndicator(
                      color: _expenseColor,
                      text: AppLocalizations.of(context)!.transactionExpense),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: chartSections(),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
