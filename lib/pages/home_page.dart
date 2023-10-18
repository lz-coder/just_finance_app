import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/home_page_graphics.dart';
import 'package:just_finance_app/pages/home_page_transactions.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/topbar.dart';
import 'package:just_finance_app/widgets/transaction_dialog.dart';

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

  insertTransaction(TransactionInfo transaction) async {
    await coreDatabase.insertTransaction(transaction);
    updateWalletValue();
  }

  updateTransaction(TransactionInfo transaction) async {
    await coreDatabase.updateTransaction(transaction);
    updateWalletValue();
  }

  removeTransaction(TransactionInfo transaction) async {
    await coreDatabase.removeTransaction(transaction);
    updateWalletValue();
  }

  updateWalletValue() async {
    var transactions = await coreDatabase.transactionsList();
    double newWalletValue = 0;
    double newIncommingValue = 0;
    double newDispenseValue = 0;
    for (var transaction in transactions) {
      if (transaction.incomming == 1) {
        newWalletValue += transaction.value;
        newIncommingValue += transaction.value;
      } else {
        newWalletValue -= transaction.value;
        newDispenseValue += transaction.value;
      }
    }
    setState(() {
      walletValue = newWalletValue;
      incommingValue = newIncommingValue;
      dispenseValue = newDispenseValue;
    });
  }

  void _showTransactionDialog(bool incomming) {
    showDialog(
        context: context,
        builder: (context) {
          return TransactionDialog(
            insertCallback: insertTransaction,
            incomming: incomming,
          );
        });
  }

  void _showEditTransactionDialog(
    Function updater,
    bool incomming,
    TransactionInfo transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          insertCallback: updater,
          incomming: incomming,
          transaction: transaction,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateWalletValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          totalValue: walletValue,
          incommingValue: incommingValue,
          dispenseValue: dispenseValue,
          changeTabCallback: changeOnHomeTab),
      floatingActionButton: onHomeTab
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 46,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 216, 94, 94),
                    onPressed: () => _showTransactionDialog(false),
                    child: const Icon(Icons.remove),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 94, 216, 94),
                  onPressed: () async {
                    _showTransactionDialog(true);
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomePageTransactions(
              dismissCallback: removeTransaction,
              transactionUpdater: updateTransaction,
              updateDialogCallback: _showEditTransactionDialog,
            ),
            const HomePageGraphics(),
          ],
        ),
      ),
    );
  }
}
