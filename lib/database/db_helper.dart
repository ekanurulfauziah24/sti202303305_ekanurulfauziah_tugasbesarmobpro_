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
    final path = join(await getDatabasesPath(), 'wisata.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS wisata');
        await _createDB(db, newVersion);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wisata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        lokasi TEXT,
        deskripsi TEXT,
        jamBuka TEXT,
        fotoPath TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<int> insertWisata(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('wisata', data);
  }

  Future<List<Map<String, dynamic>>> getAllWisata() async {
    final db = await database;
    return await db.query('wisata');
  }

  Future<int> deleteWisata(int id) async {
    final db = await database;
    return await db.delete(
      'wisata',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
