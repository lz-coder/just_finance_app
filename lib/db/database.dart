import 'package:just_finance_app/src/transaction_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const transactionsTable = 'transactions';

class TransactionsDatabase {
  late final Future<Database> _db = () async {
    return await openDatabase(
      join(await getDatabasesPath(), 'transactions_database.db'),
      onCreate: (db, version) async {
        return await db.execute(
          '''
          CREATE TABLE $transactionsTable(
            id INTEGER PRIMARY KEY,
            title TEXT,
            incomming INTEGER,
            value REAL
            )''',
        );
      },
      version: 1,
    );
  }();

  TransactionsDatabase();

  Future<void> insertTransaction(TransactionInfo transaction) async {
    final db = await _db;
    await db.insert(
      transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeTransaction(TransactionInfo transaction) async {
    final db = await _db;
    await db.delete(
      transactionsTable,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<List<TransactionInfo>> transactionsList() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (index) {
      return TransactionInfo(
        id: maps[index]['id'],
        title: maps[index]['title'],
        incomming: maps[index]['incomming'],
        value: maps[index]['value'],
      );
    });
  }

  Future<int> transactionsCount() async {
    final transactionsList = await this.transactionsList();
    return transactionsList.length;
  }
}
