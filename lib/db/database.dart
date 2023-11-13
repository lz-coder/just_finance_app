import 'package:flutter/material.dart';
import 'package:just_finance_app/src/category.dart';
import 'package:just_finance_app/src/config.dart';
import 'package:just_finance_app/src/month.dart';
import 'package:just_finance_app/src/transaction_info.dart';
import 'package:just_finance_app/src/year.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CoreDatabase {
  final _transactionsTable = 'transactions';
  final _categoriesTable = 'categories';
  final _configsTable = 'configs';
  final _monthsTable = 'months';
  final _yearsTable = 'years';

  String get transactionsTable => _transactionsTable;
  String get categoriesTable => _categoriesTable;
  String get configsTable => _configsTable;

  late final Future<Database> _db = () async {
    return await openDatabase(
      join(await getDatabasesPath(), 'core_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $_monthsTable(
            month INTEGER PRIMARY KEY
          );''',
        );
        await db.execute(
          '''
          CREATE TABLE $_yearsTable(
            year INTEGER PRIMARY KEY
          );''',
        );
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
            month INTEGER,
            year INTEGER,
            date TEXT,
            FOREIGN KEY(category) REFERENCES $_categoriesTable(id),
            FOREIGN KEY(month) REFERENCES $_monthsTable(month),
            FOREIGN KEY(year) REFERENCES $_yearsTable(year)
            );''',
        );
        await db.execute(
          '''
          CREATE TABLE $_configsTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            value TEXT
          );''',
        );

        for (var i = 1; i < 13; i++) {
          await db.insert(
            _monthsTable,
            {"month": i},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      },
      version: 1,
    );
  }();

  CoreDatabase();

  //Years//
  Future<void> insertYear(Year year) async {
    try {
      final db = await _db;
      await db.insert(
        _yearsTable,
        year.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<List<Year>?> getYears() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(_yearsTable);
      if (maps.isNotEmpty) {
        return List.generate(maps.length, (index) {
          return Year(year: maps[index]['year']);
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<List<Month>?> getMonthsFromYear({
    required int year,
    required BuildContext context,
  }) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''SELECT $_transactionsTable.month FROM $_transactionsTable
        INNER JOIN $_monthsTable ON $_monthsTable.month = $_transactionsTable.month
        WHERE year = ?
        GROUP BY $_transactionsTable.month
        ''',
        [year],
      );
      if (maps.isNotEmpty) {
        return List.generate(maps.length, (index) {
          return Month(monthNumber: maps[index]['month'], context: context);
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  //Trasactions//

  List<TransactionInfo> transactionListGenerator(
      List<Map<String, dynamic>> map) {
    return List.generate(
      map.length,
      (index) => TransactionInfo(
        id: map[index]['id'],
        title: map[index]['title'],
        income: map[index]['income'],
        value: map[index]['value'],
        category: map[index]['category'],
        categoryName: map[index]['categoryName'],
        year: map[index]['year'],
        month: map[index]['month'],
        date: map[index]['date'],
      ),
    );
  }

  Future<List<TransactionInfo>?> getTransactionsByYearMonth({
    required int year,
    required int month,
  }) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('''SELECT * FROM $transactionsTable
            WHERE year = ? AND month = ?
            ''', [year, month]);
      if (maps.isNotEmpty) {
        return transactionListGenerator(maps);
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<List<TransactionInfo>?> getTransactions({int? category}) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        _transactionsTable,
        where: category != null ? 'category = ?' : null,
        whereArgs: category != null ? [category] : null,
      );
      if (maps.isNotEmpty) {
        return transactionListGenerator(maps);
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<List<TransactionInfo>?> getTransactionsByYear(
      {required int year}) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        _transactionsTable,
        where: 'year = ?',
        whereArgs: [year],
      );
      if (maps.isNotEmpty) {
        return transactionListGenerator(maps);
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<void> insertTransaction(TransactionInfo transaction,
      {replace = true}) async {
    try {
      final db = await _db;
      await db.insert(
        _transactionsTable,
        transaction.toMap(),
        conflictAlgorithm:
            replace ? ConflictAlgorithm.replace : ConflictAlgorithm.ignore,
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<void> removeTransaction(TransactionInfo transaction) async {
    try {
      final db = await _db;
      await db.delete(
        _transactionsTable,
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<void> updateTransaction(TransactionInfo transaction) async {
    try {
      final db = await _db;
      await db.update(
        _transactionsTable,
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<int?>? transactionsCount() async {
    final transactionsList = await getTransactions();
    return transactionsList?.length;
  }
  //////

  //Categories//

  Future<List<Category>?> categoriesList() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(_categoriesTable);

      if (maps.isNotEmpty) {
        return List.generate(maps.length, (index) {
          return Category(
            id: maps[index]['id'],
            name: maps[index]['name'],
            type: maps[index]['type'],
          );
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<List<Category>?> incomeCategories() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        _categoriesTable,
        where: 'type = ?',
        whereArgs: [CategoryTypes.income],
      );
      if (maps.isNotEmpty) {
        return List.generate(maps.length, (index) {
          return Category(
            id: maps[index]['id'],
            name: maps[index]['name'],
            type: maps[index]['type'],
          );
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<List<Category>?> expenseCategories() async {
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

  Future<Category?> getCategoryById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> map = await db.query(
        _categoriesTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (map.isNotEmpty) {
        return Category(
          id: map[0]['id'],
          name: map[0]['name'],
          type: map[0]['type'],
        );
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<void> insertCategory(Category category) async {
    try {
      final db = await _db;
      await db.insert(
        _categoriesTable,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      final db = await _db;
      await db.update(
        _categoriesTable,
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      final db = await _db;
      await db.delete(
        _categoriesTable,
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  //Configs//
  Future<void> insertConfig(Config config) async {
    try {
      final db = await _db;
      await db.insert(
        _configsTable,
        config.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }

  Future<Config?> getConfig(String configName) async {
    try {
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
    } on Exception catch (e) {
      debugPrint('[error] $e');
      return null;
    }
  }

  Future<void> updateConfig(String configName, String value) async {
    try {
      final db = await _db;
      await db.update(
        _configsTable,
        {"value": value},
        where: 'name = ?',
        whereArgs: [configName],
      );
    } on Exception catch (e) {
      debugPrint('[error] $e');
    }
  }
  ////
}
