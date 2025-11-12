import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_db_model.dart';
import '../models/menu_item_db_model.dart';

class DatabaseHelper {
  static const _databaseName = "MenuDatabase.db";
  static const _databaseVersion = 1;

  // Categories table
  static const tableCategories = 'categories';
  static const columnId = 'id';
  static const columnCategoryId = 'category_id';
  static const columnName = 'name';
  static const columnImageUrl = 'image_url';
  static const columnCreatedAt = 'created_at';

  // Menu items table
  static const tableMenuItems = 'menu_items';
  static const columnItemId = 'item_id';
  static const columnDescription = 'description';
  static const columnPrice = 'price';
  static const columnPage = 'page';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create categories table
    await db.execute('''
      CREATE TABLE $tableCategories (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategoryId TEXT NOT NULL UNIQUE,
        $columnName TEXT NOT NULL,
        $columnImageUrl TEXT,
        $columnCreatedAt INTEGER NOT NULL
      )
    ''');

    // Create menu_items table
    await db.execute('''
      CREATE TABLE $tableMenuItems (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnItemId TEXT NOT NULL,
        $columnCategoryId TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnDescription TEXT,
        $columnPrice REAL NOT NULL,
        $columnImageUrl TEXT,
        $columnPage INTEGER NOT NULL,
        $columnCreatedAt INTEGER NOT NULL,
        UNIQUE($columnItemId, $columnCategoryId, $columnPage)
      )
    ''');
  }

  // Categories methods
  Future<int> insertCategory(CategoryDbModel category) async {
    Database db = await instance.database;
    return await db.insert(tableCategories, category.toMap());
  }

  Future<List<CategoryDbModel>> getCategories() async {
    Database db = await instance.database;
    List<Map> maps = await db.query(
      tableCategories,
      orderBy: '$columnCreatedAt DESC',
    );
    return maps.map((map) => CategoryDbModel.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  Future<int> deleteCategory(int id) async {
    Database db = await instance.database;
    return await db.delete(tableCategories, where: '$columnId = ?', whereArgs: [id]);
  }

  // Menu items methods
  Future<int> insertMenuItem(MenuItemDbModel menuItem) async {
    Database db = await instance.database;
    return await db.insert(tableMenuItems, menuItem.toMap());
  }

  Future<List<MenuItemDbModel>> getMenuItemsByCategoryAndPage(String categoryId, int page, int limit) async {
    Database db = await instance.database;
    List<Map> maps = await db.query(
      tableMenuItems,
      where: '$columnCategoryId = ? AND $columnPage = ?',
      whereArgs: [categoryId, page],
      limit: limit,
      orderBy: '$columnCreatedAt DESC',
    );
    return maps.map((map) => MenuItemDbModel.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  Future<int> deleteMenuItemsByCategory(String categoryId) async {
    Database db = await instance.database;
    return await db.delete(tableMenuItems, where: '$columnCategoryId = ?', whereArgs: [categoryId]);
  }

  Future<void> clearDatabase() async {
    Database db = await instance.database;
    await db.delete(tableCategories);
    await db.delete(tableMenuItems);
  }
}