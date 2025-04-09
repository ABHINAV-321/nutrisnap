import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'meals_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE meals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            calories INTEGER,
            dateTime TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    return await db.insert('meals', meal.toMap());
  }

  Future<List<Meal>> getMeals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return List.generate(maps.length, (i) {
      return Meal(
        id: maps[i]['id'],
        name: maps[i]['name'],
        calories: maps[i]['calories'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
        imagePath: maps[i]['imagePath'],
      );
    });
  }
}
