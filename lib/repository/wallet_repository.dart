import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';

final coreDatabase = CoreDatabase();

class WalletRepository extends ChangeNotifier {
  double _walletTotalValue = 0;
  double _walletIncomeValue = 0;
  double _walletExpenseValue = 0;

  WalletRepository() {
    updateWalletValue();
  }

  double get walletTotalValue => _walletTotalValue;
  double get walletIncomeValue => _walletIncomeValue;
  double get walletExpenseValue => _walletExpenseValue;

  Future<void> insertTransaction(TransactionInfo transaction) async {
    await coreDatabase.insertTransaction(transaction);
    updateWalletValue();
  }

  Future<void> updateTransaction(TransactionInfo transaction) async {
    await coreDatabase.updateTransaction(transaction);
    updateWalletValue();
  }

  Future<void> removeTransaction(TransactionInfo transaction) async {
    await coreDatabase.removeTransaction(transaction);
    updateWalletValue();
  }

  void updateWalletValue() async {
    final List<TransactionInfo>? transactions =
        await coreDatabase.getTransactions();
    double newWalletValue = 0;
    double newIncomeValue = 0;
    double newExpenseValue = 0;
    if (transactions != null) {
      for (var transaction in transactions) {
        if (transaction.income == 1) {
          newWalletValue += transaction.value;
          newIncomeValue += transaction.value;
        } else {
          newWalletValue -= transaction.value;
          newExpenseValue += transaction.value;
        }
      }
    }
    _walletTotalValue = newWalletValue;
    _walletIncomeValue = newIncomeValue;
    _walletExpenseValue = newExpenseValue;
    notifyListeners();
  }
}
