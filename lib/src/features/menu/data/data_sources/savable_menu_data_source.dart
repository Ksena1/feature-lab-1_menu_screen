import 'package:sqflite/sqflite.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_item_dto.dart';
import 'database_helper.dart';
import '../models/menu_item_db_model.dart';

abstract interface class ISavableMenuDataSource {
  Future<List<MenuItemDto>> fetchMenuItems({required String categoryId, int page = 0, int limit = 25});
  Future<void> saveMenuItems({required List<MenuItemDto> menuItems, required String categoryId, required int page});
}

final class SavableMenuDataSource implements ISavableMenuDataSource {
  final DatabaseHelper _databaseHelper;

  const SavableMenuDataSource({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<List<MenuItemDto>> fetchMenuItems({required String categoryId, int page = 0, int limit = 25}) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableMenuItems,
      where: '${DatabaseHelper.columnCategoryId} = ? AND ${DatabaseHelper.columnPage} = ?',
      whereArgs: [categoryId, page],
      limit: limit,
      orderBy: '${DatabaseHelper.columnCreatedAt} DESC',
    );

    return maps.map((map) {
      final dbModel = MenuItemDbModel.fromMap(map);
      return MenuItemDto(
        id: dbModel.itemId,
        categoryId: dbModel.categoryId,
        name: dbModel.name,
        description: dbModel.description,
        price: dbModel.price,
        imageUrl: dbModel.imageUrl,
      );
    }).toList();
  }

  @override
  Future<void> saveMenuItems({required List<MenuItemDto> menuItems, required String categoryId, required int page}) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final menuItem in menuItems) {
      final dbModel = MenuItemDbModel(
        itemId: menuItem.id,
        categoryId: categoryId,
        name: menuItem.name,
        description: menuItem.description,
        price: menuItem.price,
        imageUrl: menuItem.imageUrl,
        page: page,
        createdAt: DateTime.now(),
      );

      batch.insert(
        DatabaseHelper.tableMenuItems,
        dbModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }
}