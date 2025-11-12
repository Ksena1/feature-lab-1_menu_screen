import '../models/product_db_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  DatabaseHelper._privateConstructor();

  // Для веб-версии используем локальное хранилище
  final Map<String, List<ProductDbModel>> _memoryStorage = {};

  Future<List<ProductDbModel>> getProductsByCategoryAndPage(
    String category, 
    int page, 
    int limit
  ) async {
    final key = '$category-$page';
    return _memoryStorage[key]?.take(limit).toList() ?? [];
  }

  Future<void> insertProduct(ProductDbModel product) async {
    final key = '${product.category}-${product.page}';
    if (!_memoryStorage.containsKey(key)) {
      _memoryStorage[key] = [];
    }
    _memoryStorage[key]!.add(product);
  }

  Future<List<String>> getCategories() async {
    final categories = _memoryStorage.keys.map((key) => key.split('-').first).toSet();
    return categories.toList();
  }

  // Добавить категорию в БД
  Future<void> insertCategory(String category) async {
    print('💾 INSERTING CATEGORY TO DB: $category');
    
    // Для in-memory базы создаем пустой список продуктов для этой категории
    // Это нужно чтобы категория появилась в getCategories()
    final key = '$category-0'; // page 0
    if (!_memoryStorage.containsKey(key)) {
      _memoryStorage[key] = [];
    }
    
    print('✅ CATEGORY ADDED TO DB: $category');
  }

  Future<void> clearProducts() async {
    _memoryStorage.clear();
  }

  Future<int> getProductsCountByCategory(String category) async {
    final categoryKeys = _memoryStorage.keys.where((key) => key.startsWith('$category-'));
    int count = 0;
    for (final key in categoryKeys) {
      count += _memoryStorage[key]!.length;
    }
    return count;
  }
}