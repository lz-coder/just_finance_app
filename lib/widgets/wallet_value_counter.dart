import 'package:flutter/material.dart';
import 'package:just_finance_app/repository/wallet_repository.dart';
import 'package:just_finance_app/src/core_functions.dart';
import 'package:just_finance_app/src/currency.dart';
import 'package:provider/provider.dart';

class WalletValueCounter extends StatelessWidget {
  const WalletValueCounter({super.key, this.onTopbar = true});

  final bool onTopbar;

  @override
  Widget build(BuildContext context) {
    final totalValue = Provider.of<WalletRepository>(context).walletTotalValue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.monetization_on_outlined,
          size: 32,
          color: totalValue >= 0 ? Colors.green : Colors.red,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 20),
          child: Text(
              Currency(locale: getCurrentLocale(context)).show(totalValue),
              style: const TextStyle(fontSize: 22)),
        ),
      ],
    );
  }
}
