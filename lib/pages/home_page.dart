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
  var transactionsDbList = transactionsDb.transactionsList();

  changeOnHomeTab(bool value) {
    setState(() {
      onHomeTab = value;
    });
  }

  _updateTransactionsList() {
    setState(() {
      transactionsDbList = transactionsDb.transactionsList();
    });
  }

  insertTransaction(TransactionInfo transaction) async {
    await transactionsDb.insertTransaction(transaction);
    _updateTransactionsList();
  }

  removeTransaction(TransactionInfo transaction) async {
    await transactionsDb.removeTransaction(transaction);
  }

  void _showTransactionDialog(TransactionInfo transaction, bool incomming) {
    showDialog(
        context: context,
        builder: (context) {
          return TransactionDialog(
            insertCallback: insertTransaction,
            incomming: incomming,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(totalValue: 100, changeTabCallback: changeOnHomeTab),
      floatingActionButton: onHomeTab
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 46,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 216, 94, 94),
                    onPressed: null,
                    child: Icon(Icons.remove),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 94, 216, 94),
                  onPressed: () async {
                    late int lastTransactionId;
                    final transactionsList =
                        await transactionsDb.transactionsList();
                    if (transactionsList.isNotEmpty) {
                      lastTransactionId = transactionsList.last.id + 1;
                    } else {
                      lastTransactionId = 0;
                    }
                    final transaction = TransactionInfo(
                      id: lastTransactionId,
                      title: 'teste',
                      incomming: 1,
                      value: 1000,
                    );
                    //await insertTransaction(transaction);
                    _showTransactionDialog(transaction, true);
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
              futureBuilder: transactionsDbList,
              dismissCallback: removeTransaction,
            ),
            const Icon(Icons.graphic_eq),
          ],
        ),
      ),
    );
  }
}
