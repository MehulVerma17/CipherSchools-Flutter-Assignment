import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT CHECK(type IN ('income', 'expense')),
        date TEXT,
        time TEXT
      )
    ''');
  }

  // static Future<int> insertExpense(
  //   String expCategory,
  //   String description,
  //   int expense,
  // ) async {
  //   final db = await _openDatabase();
  //   final data = {
  //     'category': expCategory,
  //     'description': description,
  //     'expense': expense,
  //     'income': 0,
  //     'amount': 0+expense,
  //   };
  //   return await db.insert('users', data);
  // }

  Future<int> insertExpense(
    String category,
    String description,
    double amount,
    String type,
  ) async {
    final db = await _openDatabase();
    DateTime dateTime = DateTime.now(); // Capture current date & time
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return await db.insert('users', {
      'category': category,
      'description': description,
      'amount': amount,
      'type': type,
      'date': formattedDate,
      'time': formattedTime,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllExpenses() async {
    final db = await _openDatabase();
    return await db.query('users', orderBy: 'date DESC, time DESC');
  }

  Future<double> getTotalBalance() async {
    final db = await _openDatabase();
    var result = await db.rawQuery(
      "SELECT SUM(CASE WHEN type = 'income' THEN amount ELSE -amount END) AS total FROM users",
    );
    return result.first['total'] as double? ?? 0.0;
  }

  static Future<double> getTotalIncome() async {
    final db = await _openDatabase();
    var result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM users WHERE type = 'income'",
    );
    return result.first["total"] != null
        ? result.first["total"] as double
        : 0.0;
  }

  static Future<double> getTotalExpenses() async {
    final db = await _openDatabase();
    var result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM users WHERE type = 'expense'",
    );
    return result.first["total"] != null
        ? result.first["total"] as double
        : 0.0;
  }

  static Future<void> deleteData(int id) async {
    final db = await _openDatabase();
    await db.execute('DELETE FROM users WHERE id =?', [id]);
  }
}
