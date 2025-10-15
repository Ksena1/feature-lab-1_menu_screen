import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart.dart';  
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Icon(
          _getProductIcon(),
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  IconData _getProductIcon() {
    switch (product.category) {
      case 'Кофе':
        return Icons.coffee;
      case 'Десерты':
        return Icons.cake;
      case 'Выпечка':
        return Icons.bakery_dining;
      case 'Завтраки':
        return Icons.breakfast_dining;
      case 'Напитки':
        return Icons.local_drink;
      default:
        return Icons.local_cafe;
    }
  }

  Color _getCategoryColor() {
    switch (product.category) {
      case 'Кофе':
        return const Color(0xFF6F4E37);
      case 'Десерты':
        return const Color(0xFFD4A574);
      case 'Выпечка':
        return const Color(0xFFE5B880);
      case 'Завтраки':
        return const Color(0xFF8B7355);
      case 'Напитки':
        return const Color(0xFF4A7C59);
      default:
        return const Color(0xFF6F4E37);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(product.id);
    final quantity = cartProvider.getItemQuantity(product.id);
    final categoryColor = _getCategoryColor();
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        product.imageUrl!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 100.0,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderIcon();
                        },
                      ),
                    )
                  : _buildPlaceholderIcon(),
            ),
            
            const SizedBox(height: 12.0),
            
            // Название товара
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4.0),
            
            // Категория
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                product.category,
                style: TextStyle(
                  fontSize: 12,
                  color: categoryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(height: 8.0),
            
            // Цена и кнопка
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.price.toInt()} ₽',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(width: 8.0),
                
                // Кнопка покупки или счётчик
                Expanded(
                  child: !isInCart
                      ? SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: categoryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () {
                              cartProvider.addToCart(CartItem(
                                productId: product.id,
                                name: product.name,
                                price: product.price,
                                category: product.category,
                                imageUrl: product.imageUrl,
                                quantity: 1,
                              ));
                            },
                            child: const Text(
                              'В корзину',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: categoryColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: categoryColor,
                                ),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () {
                                  final newQuantity = quantity - 1;
                                  if (newQuantity <= 0) {
                                    cartProvider.removeFromCart(product.id);
                                  } else {
                                    cartProvider.updateItemQuantity(product.id, newQuantity);
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: categoryColor,
                                ),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () {
                                  if (quantity < 10) {
                                    cartProvider.updateItemQuantity(product.id, quantity + 1);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}