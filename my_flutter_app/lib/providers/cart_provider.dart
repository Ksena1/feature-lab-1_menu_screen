import 'package:flutter/foundation.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart();

  Cart get cart => _cart;
  
  int get totalItems => _cart.totalItems;
  
  double get totalPrice => _cart.totalPrice;

  void addToCart(CartItem item) {
    _cart.addItem(item);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  void updateItemQuantity(String productId, int quantity) {
    _cart.updateQuantity(productId, quantity);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cart.contains(productId);
  }

  int getItemQuantity(String productId) {
    return _cart.getQuantity(productId);
  }
}