import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/profile_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('test_2.db');
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

  Future<Map> retrieveTotalCaloriesAndEntries() async {
    List<Map<String, dynamic>> entries = await retrieveFoodEntries();
    int totalCalories = 0;
    int totalEntries = entries.length;
    for (Map<String, dynamic> entry in entries) {
      totalCalories += (entry['calories'] as int);
    }
    return {
      'totalCalories': totalCalories,
      'totalEntries': totalEntries,
    };
  }

  Future<int> getTotalCaloriesForDate(DateTime date) async {
    Database db = await instance.database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final List<Map<String, dynamic>> entries = await db.query(
      'food_entry',
      where: 'time >= ? AND time < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String()
      ],
    );

    return entries.fold<int>(
        0, (int sum, item) => sum + (item['calories'] as int));
  }

  Future<void> updateFoodItems(int id, String foodItems) async {
    Database db = await instance.database;
    await db.rawUpdate('''
      UPDATE food_entry
      SET foodItems = ?
      WHERE id = ?
    ''', [foodItems, id]);
  }

  Future<void> updateNotes(int id, String notes) async {
    Database db = await instance.database;
    await db.rawUpdate('''
      UPDATE food_entry
      SET notes = ?
      WHERE id = ?
    ''', [notes, id]);
  }

  Future<ProfileModel> getProfileData() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('user_profile');

    if (maps.isEmpty) {
      throw Exception('No profile found');
    }

    return ProfileModel.fromMap(maps.first);
  }

  Future<void> createProfileData(ProfileModel profile) async {
    final Database db = await instance.database;
    await db.insert(
      'user_profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProfileData(int id, ProfileModel profile) async {
    final Database db = await instance.database;
    await db.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getWaterIntakeForDate(
      DateTime date) async {
    Database db = await instance.database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return await db.query(
      'water_intake',
      where: 'time >= ? AND time < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch
      ],
      orderBy: 'time DESC',
    );
  }

  Future<int> getTotalWaterIntakeForDate(DateTime date) async {
    final intakes = await getWaterIntakeForDate(date);
    return intakes.fold<int>(
        0, (int sum, item) => sum + (item['amount'] as int));
  }

  Future<int> addWaterIntake(int amount) async {
    Database db = await instance.database;
    return await db.insert('water_intake', {
      'amount': amount,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
