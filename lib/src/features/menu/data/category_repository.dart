import 'dart:io';
import 'package:flutter_course/src/features/menu/data/data_sources/categories_data_source.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/savable_categories_data_source.dart';
import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/utils/category_mapper.dart';

abstract interface class ICategoryRepository {
  Future<List<MenuCategory>> loadCategories();
}

final class CategoriesRepository implements ICategoryRepository {
  final ICategoriesDataSource _networkCategoriesDataSource;
  final ISavableCategoriesDataSource _dbCategoriesDataSource;

  const CategoriesRepository({
    required ICategoriesDataSource networkCategoriesDataSource,
    required ISavableCategoriesDataSource dbCategoriesDataSource,
  })  : _networkCategoriesDataSource = networkCategoriesDataSource,
        _dbCategoriesDataSource = dbCategoriesDataSource;

  @override
  Future<List<MenuCategory>> loadCategories() async {
    var dtos = <MenuCategoryDto>[];
    try {
      // Пытаемся загрузить из сети
      dtos = await _networkCategoriesDataSource.fetchCategories();
      // Сохраняем в БД
      await _dbCategoriesDataSource.saveCategories(categories: dtos);
    } on SocketException {
      // Если нет сети, загружаем из БД
      dtos = await _dbCategoriesDataSource.fetchCategories();
    }
    return dtos.map((e) => e.toModel()).toList();
  }
}