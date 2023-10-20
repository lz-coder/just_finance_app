import 'package:flutter/material.dart';
import 'package:just_finance_app/db/database.dart';
import 'package:just_finance_app/src/transaction_info.dart';

final coreDatabase = CoreDatabase();

class WalletRepository extends ChangeNotifier {
  double _walletTotalValue = 0;
  double _walletIncommingValue = 0;
  double _walletDispenseValue = 0;

  WalletRepository() {
    updateWalletValue();
  }

  double get walletTotalValue => _walletTotalValue;
  double get walletIncommingValue => _walletIncommingValue;
  double get walletDispenseValue => _walletDispenseValue;

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
    _walletTotalValue = newWalletValue;
    _walletIncommingValue = newIncommingValue;
    _walletDispenseValue = newDispenseValue;
    notifyListeners();
  }
}
