import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/models/cart.dart';
import 'package:my_flutter_app/models/product.dart';
import 'package:my_flutter_app/data/database/repositories/products_repository.dart';
import 'package:my_flutter_app/data/database/data_sources/network_products_data_source.dart';
import 'package:my_flutter_app/data/database/data_sources/savable_products_data_source.dart';
import 'package:my_flutter_app/data/database/data_sources/database_helper.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart();
  final ProductsRepository _productsRepository;

  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _currentCategory = '';

  CartProvider() : _productsRepository = ProductsRepository(
          networkDataSource: NetworkProductsDataSource(),
          dbDataSource: SavableProductsDataSource(
            databaseHelper: DatabaseHelper.instance,
          ),
        ) {
    _loadCategories();
  }

  // Геттер для items
  List<CartItem> get items => _cart.items;
  
  // Геттер для общего количества товаров
  int get totalItems => _cart.totalItems;
  
  // Геттер для общей стоимости
  double get totalPrice => _cart.totalPrice;

  // Новые геттеры для БД
  List<Product> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCategory => _currentCategory;

  // Загрузка категорий из БД/сети
  Future<void> _loadCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Используем репозиторий который сам решит откуда брать данные
      _categories = await _productsRepository.loadCategories();
      
      // Загружаем продукты для первой категории
      if (_categories.isNotEmpty) {
        await loadProductsByCategory(_categories.first);
      }
      
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки категорий: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Загрузка продуктов по категории с пагинацией
  Future<void> loadProductsByCategory(String category, {int page = 0}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Используем репозиторий с пагинацией
      final newProducts = await _productsRepository.loadProductsByCategory(category, page, 10);
      
      if (page == 0) {
        _products = newProducts;
        _currentCategory = category;
      } else {
        _products.addAll(newProducts);
      }
      
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки продуктов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Добавить товар в корзину
  void addToCart(Product product) {
    print('➕ ${product.name} - ${product.price} ₽');
    
    final cartItem = CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      category: product.category,
      imageUrl: product.imageUrl,
      quantity: 1,
    );
    
    _cart.addItem(cartItem);
    notifyListeners();
  }

  // Удалить товар из корзины
  void removeFromCart(String productId) {
    final itemToRemove = _cart.items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => throw StateError('Product not found'),
    );
    
    print('➖ ${itemToRemove.name}');
    
    _cart.removeItem(productId);
    notifyListeners();
  }

  // Обновить количество
  void updateQuantity(String productId, int newQuantity) {
    _cart.updateQuantity(productId, newQuantity);
    notifyListeners();
  }

  // Очистить корзину
  void clearCart() {
    print('🗑️ CLEAR CART');
    _cart.clear();
    notifyListeners();
  }

  // Проверить, есть ли товар в корзине
  bool isProductInCart(String productId) {
    return _cart.contains(productId);
  }

  // Получить количество конкретного товара
  int getProductQuantity(String productId) {
    return _cart.getQuantity(productId);
  }

  // Загрузить следующую страницу продуктов
  Future<void> loadMoreProducts() async {
    if (_currentCategory.isNotEmpty) {
      final currentPage = (_products.length / 10).ceil();
      await loadProductsByCategory(_currentCategory, page: currentPage);
    }
  }
}