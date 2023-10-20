import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/pages/home_page_graphics.dart';
import 'package:just_finance_app/pages/home_page_transactions.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/create_transaction_buttons.dart';
import 'package:just_finance_app/widgets/topbar.dart';
import 'package:just_finance_app/widgets/transaction_dialog.dart';
import 'package:provider/provider.dart';

import '../db/database.dart';

final coreDatabase = CoreDatabase();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var onHomeTab = true;
  double walletValue = 0;
  double incommingValue = 0;
  double dispenseValue = 0;

  changeOnHomeTab(bool value) {
    setState(() {
      onHomeTab = value;
    });
  }

  void _showTransactionDialog(bool incomming) {
    showDialog(
        context: context,
        builder: (context) {
          return TransactionDialog(
            incomming: incomming,
          );
        });
  }

  void _showEditTransactionDialog(
    bool incomming,
    TransactionInfo transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          incomming: incomming,
          transaction: transaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(changeTabCallback: changeOnHomeTab),
      floatingActionButton: onHomeTab
          ? CreateTransactionButtons(dialogCallback: _showTransactionDialog)
          : null,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Consumer<WalletRepository>(builder: (context, value, child) {
              return HomePageTransactions(
                updateDialogCallback: _showEditTransactionDialog,
              );
            }),
            const HomePageGraphics(),
          ],
        ),
      ),
    );
  }
}
