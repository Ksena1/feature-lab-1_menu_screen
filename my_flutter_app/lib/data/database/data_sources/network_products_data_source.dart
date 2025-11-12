import 'package:my_flutter_app/models/product.dart';

abstract interface class INetworkProductsDataSource {
  Future<List<Product>> loadProductsByCategory(String category, int page, int limit);
  Future<List<String>> loadCategories();
}

final class NetworkProductsDataSource implements INetworkProductsDataSource {
  @override
  Future<List<Product>> loadProductsByCategory(String category, int page, int limit) async {
    // Имитация сетевого запроса с пагинацией
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Здесь должен быть реальный HTTP запрос к бэку
    // Для примера возвращаем mock данные
    return _generateMockProducts(category, page, limit);
  }

  @override
  Future<List<String>> loadCategories() async {
    // Имитация сетевого запроса для категорий
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Здесь должен быть реальный HTTP запрос к бэку
    return ['Кофе', 'Десерты', 'Выпечка', 'Завтраки', 'Чай'];
  }

  List<Product> _generateMockProducts(String category, int page, int limit) {
    // Генерация mock данных с учетом пагинации
    final startIndex = page * limit;
    final products = <Product>[];
    
    for (int i = 0; i < limit; i++) {
      final index = startIndex + i;
      products.add(Product(
        id: '${category}_$index',
        name: '$category продукт ${index + 1}',
        description: 'Описание $category продукта ${index + 1}',
        price: 100 + (index * 10),
        imageUrl: 'assets/images/${category.toLowerCase()}_$index.jpg',
        category: category,
      ));
    }
    
    return products;
  }
}