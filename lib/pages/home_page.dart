import 'package:flutter/material.dart';
import 'package:just_finance_app/pages/home_page_transactions.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/topbar.dart';
import 'package:just_finance_app/widgets/transaction_dialog.dart';

import '../db/database.dart';

final transactionsDb = TransactionsDatabase();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var onHomeTab = true;
  double walletValue = 0;

  changeOnHomeTab(bool value) {
    setState(() {
      onHomeTab = value;
    });
  }

  insertTransaction(TransactionInfo transaction) async {
    await transactionsDb.insertTransaction(transaction);
    setState(() {
      if (transaction.incomming == 1) {
        walletValue += transaction.value;
      } else {
        walletValue -= transaction.value;
      }
    });
  }

  updateTransaction(TransactionInfo transaction) async {
    await transactionsDb.updateTransaction(transaction);
    updateWalletValue();
  }

  removeTransaction(TransactionInfo transaction) async {
    await transactionsDb.removeTransaction(transaction);
    updateWalletValue();
  }

  updateWalletValue() async {
    var transactions = await transactionsDb.transactionsList();
    double value = 0;
    for (var transaction in transactions) {
      if (transaction.incomming == 1) {
        value += transaction.value;
      } else {
        value -= transaction.value;
      }
    }
    setState(() {
      walletValue = value;
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
    // TODO: implement initState
    super.initState();
    updateWalletValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          TopBar(totalValue: walletValue, changeTabCallback: changeOnHomeTab),
      floatingActionButton: onHomeTab
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 46,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 216, 94, 94),
                    onPressed: () => _showTransactionDialog(false),
                    child: Icon(Icons.remove),
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
        padding: const EdgeInsets.all(10),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomePageTransactions(
              dismissCallback: removeTransaction,
              transactionUpdater: updateTransaction,
              updateDialogCallback: _showEditTransactionDialog,
            ),
            const Icon(Icons.graphic_eq),
          ],
        ),
      ),
    );
  }
}
