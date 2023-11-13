import 'package:flutter/material.dart';
import 'package:just_finance_app/repository/date_repository.dart';
import 'package:just_finance_app/repository/wallet_repository.dart';
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
    final dateProvider = Provider.of<DateRepository>(context, listen: false);

    bool canCreateTransactions = false;
    Widget? goHomeButton;
    if (onHomeTab) {
      if ((currentYear == selectedYear && currentMonth == selectedMonth) ||
          (currentYear == selectedYear && selectedMonth == null) ||
          (selectedMonth == null && selectedYear == null)) {
        canCreateTransactions = true;
      } else {
        goHomeButton = SizedBox(
          width: 150,
          child: FloatingActionButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            backgroundColor: Colors.blue,
            onPressed: () {
              dateProvider.selectedMonth = currentMonth;
              dateProvider.selectedYear = currentYear;
            },
            child:
                const Row(children: [Icon(Icons.home), Text('Current Month')]),
          ),
        );
      }
    }

    return Scaffold(
      appBar: TopBar(changeTabCallback: _changeOnHomeTab),
      floatingActionButton: canCreateTransactions
          ? CreateTransactionButtons(dialogCallback: _showTransactionDialog)
          : goHomeButton,
      floatingActionButtonLocation: goHomeButton != null && onHomeTab
          ? FloatingActionButtonLocation.centerFloat
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
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
                        return YearDrawerButton(
                          year:
                              snapshot.data![snapshot.data!.length - index - 1],
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
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
