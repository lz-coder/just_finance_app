import 'package:just_finance_app/src/category.dart';
import 'package:just_finance_app/src/config.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CoreDatabase {
  final _transactionsTable = 'transactions';
  final _categoriesTable = 'categories';
  final _configsTable = 'configs';

  late final Future<Database> _db = () async {
    return await openDatabase(
      join(await getDatabasesPath(), 'core_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $_categoriesTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT
          );''',
        );
        await db.execute(
          '''
          CREATE TABLE $_transactionsTable(
            id INTEGER PRIMARY KEY,
            title TEXT,
            income INTEGER,
            value REAL,
            category INTEGER,
            categoryName TEXT,
            FOREIGN KEY(category) REFERENCES _categoriesTable(id)
            );''',
        );
        await db.execute('''
          CREATE TABLE $_configsTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            value TEXT
          )
          ''');
      },
      version: 1,
    );
  }();

  CoreDatabase();

  //Trasactions//

  Future<void> insertTransaction(TransactionInfo transaction,
      {replace = true}) async {
    final db = await _db;
    await db.insert(
      _transactionsTable,
      transaction.toMap(),
      conflictAlgorithm:
          replace ? ConflictAlgorithm.replace : ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeTransaction(TransactionInfo transaction) async {
    final db = await _db;
    await db.delete(
      _transactionsTable,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> updateTransaction(TransactionInfo transaction) async {
    final db = await _db;
    await db.update(
      _transactionsTable,
      transaction.toMap(),
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
        income: maps[index]['income'],
        value: maps[index]['value'],
        category: maps[index]['category'],
        categoryName: maps[index]['categoryName'],
      );
    });
  }

  Future<int> transactionsCount() async {
    final transactionsList = await this.transactionsList();
    return transactionsList.length;
  }
  //////

  //Categories//

  Future<List<Category>> categoriesList() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(_categoriesTable);

    return List.generate(maps.length, (index) {
      return Category(
        id: maps[index]['id'],
        name: maps[index]['name'],
        type: maps[index]['type'],
      );
    });
  }

  Future<List<Category>> incomeCategories() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTable,
      where: 'type = ?',
      whereArgs: [CategoryTypes.income],
    );
    return List.generate(maps.length, (index) {
      return Category(
        id: maps[index]['id'],
        name: maps[index]['name'],
        type: maps[index]['type'],
      );
    });
  }

  Future<List<Category>> expenseCategories() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTable,
      where: 'type = ?',
      whereArgs: [CategoryTypes.expense],
    );
    return List.generate(maps.length, (index) {
      return Category(
        id: maps[index]['id'],
        name: maps[index]['name'],
        type: maps[index]['type'],
      );
    });
  }

  Future<Category> getCategoryById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> map = await db.query(
      _categoriesTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return Category(
      id: map[0]['id'],
      name: map[0]['name'],
      type: map[0]['type'],
    );
  }

  Future<void> insertCategory(Category categorie) async {
    final db = await _db;
    await db.insert(
      _categoriesTable,
      categorie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCategory(Category categorie) async {
    final db = await _db;
    await db.update(
      _categoriesTable,
      categorie.toMap(),
      where: 'id = ?',
      whereArgs: [categorie.id],
    );
  }

  //Configs//
  Future<void> insertConfig(Config config) async {
    final db = await _db;
    await db.insert(
      _configsTable,
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Config?> getConfig(String configName) async {
    final db = await _db;
    final List<Map<String, dynamic>> map = await db.query(
      _configsTable,
      where: 'name = ?',
      whereArgs: [configName],
    );
    if (map.isNotEmpty) {
      return Config(
        id: map[0]['id'],
        name: map[0]['name'],
        value: map[0]['value'],
      );
    } else {
      return null;
    }
  }

  Future<void> updateConfig(String configName, String value) async {
    final db = await _db;
    await db.update(
      _configsTable,
      {"value": value},
      where: 'name = ?',
      whereArgs: [configName],
    );
  }
  ////
}
