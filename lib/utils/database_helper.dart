import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('test_1.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_entry (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image BLOB,
        mealType TEXT NOT NULL,
        foodItems TEXT NOT NULL,
        notes TEXT NOT NULL,
        calories INTEGER NOT NULL,
        time DATETIME NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        age INTEGER NOT NULL,
        weight INTEGER NOT NULL,
        height INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE water_intake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        time INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> retrieveFoodEntriesSortedByLatest() async {
    Database db = await instance.database;
    return await db.query('food_entry', orderBy: 'time DESC');
  }

  Future<List<Map<String, dynamic>>> retrieveFoodEntries() async {
    Database db = await instance.database;
    return await db.query('food_entry');
  }

  Future<Map<String, dynamic>> retrieveFoodEntry(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> entries =
        await db.query('food_entry', where: 'id = ?', whereArgs: [id]);
    return entries.first;
  }

  Future<int> updateFoodEntry(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('food_entry', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteFoodEntry(int id) async {
    Database db = await instance.database;
    return await db.delete('food_entry', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createWaterIntake(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('water_intake', row);
  }

  Future<int> createProfile(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('user_profile', row);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
