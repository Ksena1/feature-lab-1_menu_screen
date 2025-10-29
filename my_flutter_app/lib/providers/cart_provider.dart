import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../models/order.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart();
  final ApiService _apiService = ApiService();

  List<CartItem> get items => _cart.items;
  int get totalItems => _cart.totalItems;
  double get totalPrice => _cart.totalPrice;

  void addToCart(Product product) {
    final cartItem = CartItem(
      productId: product.id.toString(),
      name: product.name,
      price: product.price,
      category: product.category,
      imageUrl: product.imageUrl,
      quantity: 1,
    );
    _cart.addItem(cartItem);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    _cart.updateQuantity(productId, newQuantity);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  bool isProductInCart(String productId) {
    return _cart.contains(productId);
  }

  int getProductQuantity(String productId) {
    return _cart.getQuantity(productId);
  }

  Future<void> submitOrder() async {
    if (_cart.items.isEmpty) {
      throw Exception('Cart is empty');
    }

    final Map<String, int> positions = {};
    for (final item in _cart.items) {
      positions[item.productId] = item.quantity;
    }

    final orderRequest = OrderRequest(positions: positions);
    
    try {
      await _apiService.createOrder(orderRequest);
    } catch (e) {
      print('Order submission error: $e');
    }
  }
}