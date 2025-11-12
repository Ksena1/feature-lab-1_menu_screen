import 'package:sqflite/sqflite.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';
import 'database_helper.dart';
import '../models/category_db_model.dart';

abstract interface class ISavableCategoriesDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
  Future<void> saveCategories({required List<MenuCategoryDto> categories});
}

final class SavableCategoriesDataSource implements ISavableCategoriesDataSource {
  final DatabaseHelper _databaseHelper;

  const SavableCategoriesDataSource({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<List<MenuCategoryDto>> fetchCategories() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableCategories,
      orderBy: '${DatabaseHelper.columnCreatedAt} DESC',
    );

    return maps.map((map) {
      final dbModel = CategoryDbModel.fromMap(map);
      return MenuCategoryDto(
        id: dbModel.categoryId,
        name: dbModel.name,
        imageUrl: dbModel.imageUrl,
      );
    }).toList();
  }

  @override
  Future<void> saveCategories({required List<MenuCategoryDto> categories}) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final category in categories) {
      final dbModel = CategoryDbModel(
        categoryId: category.id,
        name: category.name,
        imageUrl: category.imageUrl,
        createdAt: DateTime.now(),
      );

      batch.insert(
        DatabaseHelper.tableCategories,
        dbModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }
}