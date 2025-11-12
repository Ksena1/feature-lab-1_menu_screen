import 'package:flutter_course/src/features/menu/models/dto/menu_category_dto.dart';

abstract interface class ICategoriesDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
}

// Заглушка для сетевого data source - замените на реальную реализацию
final class NetworkCategoriesDataSource implements ICategoriesDataSource {
  @override
  Future<List<MenuCategoryDto>> fetchCategories() async {
    // TODO: Реализовать реальный сетевой запрос
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      MenuCategoryDto(
        id: 'coffee',
        name: 'Coffee',
        imageUrl: 'assets/images/coffee.jpg',
      ),
      MenuCategoryDto(
        id: 'tea', 
        name: 'Tea',
        imageUrl: 'assets/images/tea.jpg',
      ),
      MenuCategoryDto(
        id: 'desserts',
        name: 'Desserts',
        imageUrl: 'assets/images/desserts.jpg',
      ),
    ];
  }
}
