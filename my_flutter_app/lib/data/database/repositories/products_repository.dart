import 'package:my_flutter_app/data/database/data_sources/network_products_data_source.dart';
import 'package:my_flutter_app/data/database/data_sources/savable_products_data_source.dart';
import 'package:my_flutter_app/models/product.dart';

abstract interface class IProductsRepository {
  Future<List<Product>> loadProductsByCategory(String category, int page, int limit);
  Future<List<String>> loadCategories();
}

final class ProductsRepository implements IProductsRepository {
  final NetworkProductsDataSource networkDataSource;
  final SavableProductsDataSource dbDataSource;

  ProductsRepository({
    required this.networkDataSource,
    required this.dbDataSource,
  });

  @override
  Future<List<Product>> loadProductsByCategory(String category, int page, int limit) async {
    try {
      print('🌐 LOADING FROM NETWORK: $category, page $page');
      
      // 1. Пробуем загрузить из сети
      final products = await networkDataSource.loadProductsByCategory(category, page, limit);
      
      // 2. СОХРАНЯЕМ в БД после успешной загрузки с бэка
      await dbDataSource.saveProducts(products, category, page);
      
      print('✅ SUCCESS: Loaded ${products.length} products from network and saved to DB');
      return products;
      
    } catch (e) {
      print('❌ NETWORK ERROR: $e');
      print('💾 FALLBACK: Loading from database...');
      
      // 3. Fallback: загружаем из БД если нет доступа в сеть
      final dbProducts = await dbDataSource.fetchProductsByCategory(category, page, limit);
      
      print('✅ SUCCESS: Loaded ${dbProducts.length} products from database');
      return dbProducts;
    }
  }

  @override
  Future<List<String>> loadCategories() async {
    try {
      print('🌐 LOADING CATEGORIES FROM NETWORK');
      
      // 1. Пробуем загрузить из сети
      final categories = await networkDataSource.loadCategories();
      
      // 2. СОХРАНЯЕМ категории в БД
      await dbDataSource.saveCategories(categories);
      
      print('✅ SUCCESS: Loaded ${categories.length} categories from network and saved to DB');
      return categories;
      
    } catch (e) {
      print('❌ NETWORK ERROR: $e');
      print('💾 FALLBACK: Loading categories from database...');
      
      // 3. Fallback: загружаем из БД если нет доступа в сеть
      final dbCategories = await dbDataSource.fetchCategories();
      
      print('✅ SUCCESS: Loaded ${dbCategories.length} categories from database');
      return dbCategories;
    }
  }
}