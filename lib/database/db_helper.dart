import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "wisata.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wisata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        deskripsi TEXT,
        image TEXT,
        lat REAL,
        lng REAL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllWisata() async {
    final db = await database;
    return await db.query('wisata');
  }

  Future<int> insertWisata(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('wisata', data);
  }
}
