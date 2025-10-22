import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          if (cartProvider.totalItems > 0)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Очистить корзину'),
                    content: const Text('Вы уверены, что хотите очистить корзину?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Очистить'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartProvider.totalItems == 0
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Корзина пуста',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (ctx, index) {
                      final item = cartProvider.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: item.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    _getCategoryIcon(item.category),
                                    color: _getCategoryColor(item.category),
                                  ),
                          ),
                          title: Text(item.name),
                          subtitle: Text('${item.price} ₽ × ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.totalPrice} ₽',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeFromCart(item.productId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cartProvider.totalItems} товара',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Итого: ${cartProvider.totalPrice} ₽',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Заказ оформлен!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text('Оформить заказ'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Кофе':
        return Icons.coffee;
      case 'Десерты':
        return Icons.cake;
      case 'Выпечка':
        return Icons.bakery_dining;
      case 'Завтраки':
        return Icons.breakfast_dining;
      default:
        return Icons.local_cafe;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Кофе':
        return const Color(0xFF6F4E37);
      case 'Десерты':
        return const Color(0xFFD4A574);
      case 'Выпечка':
        return const Color(0xFFE5B880);
      case 'Завтраки':
        return const Color(0xFF8B7355);
      default:
        return const Color(0xFF6F4E37);
    }
  }
}