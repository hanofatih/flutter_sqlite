import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/borrower.dart';
import '../Models/loan.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE borrowers (id INTEGER PRIMARY KEY AUTOINCREMENT, fullname TEXT, phone TEXT)');
        await db.execute(
            'CREATE TABLE loans (id INTEGER PRIMARY KEY AUTOINCREMENT, borrower_id INTEGER, amount REAL, date TEXT, FOREIGN KEY (borrower_id) REFERENCES borrowers (id))');
      },
    );
  }

  Future<void> insertBorrower(Borrower borrower) async {
    final db = await database;
    await db.insert('borrowers', borrower.toMap());
  }

  Future<void> insertLoan(Loan loan) async {
    final db = await database;
    await db.insert('loans', loan.toMap());
  }

  Future<List<Borrower>> getBorrowers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('borrowers');
    return List.generate(maps.length, (i) => Borrower.fromMap(maps[i]));
  }

  Future<List<Loan>> getLoans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT loans.id, loans.borrower_id, loans.amount, loans.date, borrowers.fullname, borrowers.phone FROM loans JOIN borrowers ON loans.borrower_id = borrowers.id;');
    return List.generate(maps.length, (i) => Loan.fromMap(maps[i]));
  }

  Future<int> deleteBorrower(int id) async {
    final db = await database;
    return await db.delete('borrowers', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteLoan(int id) async {
    final db = await database;
    return await db.delete('loans', where: 'id = ?', whereArgs: [id]);
  }
}
