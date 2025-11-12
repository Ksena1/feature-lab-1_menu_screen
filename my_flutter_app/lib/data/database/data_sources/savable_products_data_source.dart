import 'package:my_flutter_app/models/product.dart';
import 'database_helper.dart';
import '../models/product_db_model.dart';

abstract interface class ISavableProductsDataSource {
  Future<List<Product>> fetchProductsByCategory(String category, int page, int limit);
  Future<void> saveProducts(List<Product> products, String category, int page);
  Future<List<String>> fetchCategories();
  Future<void> saveCategories(List<String> categories);
}

final class SavableProductsDataSource implements ISavableProductsDataSource {
  final DatabaseHelper _databaseHelper;

  const SavableProductsDataSource({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<List<Product>> fetchProductsByCategory(String category, int page, int limit) async {
    print('💾 LOADING FROM DB: $category, page $page, limit $limit');
    
    // Данные с БД также имеют пагинацию
    final dbProducts = await _databaseHelper.getProductsByCategoryAndPage(category, page, limit);
    
    print('✅ LOADED ${dbProducts.length} products from database');
    
    return dbProducts.map((dbProduct) {
      return Product(
        id: dbProduct.productId,
        name: dbProduct.name,
        description: dbProduct.description,
        price: dbProduct.price,
        imageUrl: dbProduct.imageUrl,
        category: dbProduct.category,
      );
    }).toList();
  }

  @override
  Future<void> saveProducts(List<Product> products, String category, int page) async {
    print('💾 SAVING ${products.length} PRODUCTS TO DATABASE');
    print('   Category: $category, Page: $page');
    
    final batchProducts = products.map((product) {
      return ProductDbModel(
        productId: product.id,
        category: category,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        page: page,
        createdAt: DateTime.now(),
      );
    }).toList();

    for (final product in batchProducts) {
      await _databaseHelper.insertProduct(product);
    }
    
    print('✅ PRODUCTS SAVED TO DATABASE SUCCESSFULLY');
  }

  @override
  Future<List<String>> fetchCategories() async {
    print('💾 LOADING CATEGORIES FROM DATABASE');
    final categories = await _databaseHelper.getCategories();
    print('✅ LOADED ${categories.length} categories from database');
    return categories;
  }

  @override
  Future<void> saveCategories(List<String> categories) async {
    print('💾 SAVING ${categories.length} CATEGORIES TO DATABASE');
    
    // Сохраняем категории в БД
    for (final category in categories) {
      await _databaseHelper.insertCategory(category);
    }
    
    print('✅ CATEGORIES SAVED TO DATABASE SUCCESSFULLY');
  }
}