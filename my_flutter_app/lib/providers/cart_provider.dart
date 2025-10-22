import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/models/cart.dart';
import 'package:my_flutter_app/models/product.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart();

  // Геттер для items
  List<CartItem> get items => _cart.items;
  
  // Геттер для общего количества товаров
  int get totalItems => _cart.totalItems;
  
  // Геттер для общей стоимости
  double get totalPrice => _cart.totalPrice;

  // Добавить товар в корзину
  void addToCart(Product product) {
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
    _cart.removeItem(productId);
    notifyListeners();
  }

  // Обновить количество - ДОБАВЬТЕ ЭТОТ МЕТОД
  void updateQuantity(String productId, int newQuantity) {
    _cart.updateQuantity(productId, newQuantity);
    notifyListeners();
  }

  // Очистить корзину
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Проверить, есть ли товар в корзине
  bool isProductInCart(String productId) {
    return _cart.contains(productId);
  }

  // Получить количество конкретного товара - ДОБАВЬТЕ ЭТОТ МЕТОД
  int getProductQuantity(String productId) {
    return _cart.getQuantity(productId);
  }
}