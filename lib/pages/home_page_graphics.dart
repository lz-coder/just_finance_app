import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/src/core_functions.dart';
import 'package:just_finance_app/src/currency.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageGraphics extends StatelessWidget {
  const HomePageGraphics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final incommingValue =
        Provider.of<WalletRepository>(context).walletIncommingValue;
    final dispenseValue =
        Provider.of<WalletRepository>(context).walletDispenseValue;
    final pieData = <_PieData>[
      _PieData(AppLocalizations.of(context)!.transactionIncomming,
          incommingValue, AppLocalizations.of(context)!.transactionIncomming),
      _PieData(AppLocalizations.of(context)!.transactionDispense, dispenseValue,
          AppLocalizations.of(context)!.transactionDispense),
    ];
    if (incommingValue > 0 || dispenseValue > 0) {
      return Center(
        child: SfCircularChart(
          title: ChartTitle(text: AppLocalizations.of(context)!.mainGraphTitle),
          legend: const Legend(isVisible: true),
          palette: const [
            Color.fromARGB(204, 83, 117, 76),
            Color.fromARGB(204, 117, 76, 76),
          ],
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
              animationDuration: 700,
              explode: false,
              explodeIndex: 0,
              dataSource: pieData,
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) =>
                  '${data.text} \n ${Currency(locale: getCurrentLocale(context)).show(data.yData)}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.graphPageNoData,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}
