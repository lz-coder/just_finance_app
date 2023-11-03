import 'package:flutter/material.dart';
import 'package:just_finance_app/Repository/date_repository.dart';
import 'package:just_finance_app/Repository/wallet_repository.dart';
import 'package:just_finance_app/pages/home_page_graphics.dart';
import 'package:just_finance_app/pages/home_page_transactions.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/widgets/create_transaction_buttons.dart';
import 'package:just_finance_app/widgets/topbar.dart';
import 'package:just_finance_app/widgets/transaction_dialog.dart';
import 'package:just_finance_app/widgets/wallet_value_counter.dart';
import 'package:just_finance_app/widgets/year_drawer_button.dart';
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

  _changeOnHomeTab(bool value) {
    setState(() {
      onHomeTab = value;
    });
  }

  void _showTransactionDialog(bool income) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(income: income);
      },
    );
  }

  void _showEditTransactionDialog(
    bool income,
    TransactionInfo transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          income: income,
          transaction: transaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentYear =
        Provider.of<DateRepository>(context, listen: false).currentYear;
    final currentMonth =
        Provider.of<DateRepository>(context, listen: false).currentMonth;
    final selectedYear = Provider.of<DateRepository>(context).selectedYear;
    final selectedMonth = Provider.of<DateRepository>(context).selectedMonth;

    bool canCreateTransactions = false;
    if (onHomeTab) {
      if (currentYear == selectedYear && currentMonth == selectedMonth ||
          selectedMonth == null && selectedYear == null) {
        canCreateTransactions = true;
      }
    }

    return Scaffold(
      appBar: TopBar(changeTabCallback: _changeOnHomeTab),
      floatingActionButton: canCreateTransactions
          ? CreateTransactionButtons(dialogCallback: _showTransactionDialog)
          : null,
      body: TabBarView(
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
      drawer: Drawer(
        //width: 240,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                child: WalletValueCounter(),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: coreDatabase.getYears(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return YearDrawerButton(year: snapshot.data![index]);
                      },
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
