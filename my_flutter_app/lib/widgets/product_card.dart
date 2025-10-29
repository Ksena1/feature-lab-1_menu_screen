import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        _getProductIcon(),
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }

  IconData _getProductIcon() {
    switch (widget.product.category) {
      case 'Кофе':
        return Icons.coffee;
      case 'Десерты':
        return Icons.cake;
      case 'Выпечка':
        return Icons.bakery_dining;
      case 'Завтраки':
        return Icons.breakfast_dining;
      case 'Чай':
        return Icons.emoji_food_beverage;
      case 'Напитки':
        return Icons.local_drink;
      default:
        return Icons.local_cafe;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    // FIX: toString() для int -> String
    final quantity = cart.getProductQuantity(widget.product.id.toString());
    final isInCart = quantity > 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // КАРТИНКА
            Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: widget.product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        widget.product.imageUrl!,
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
            const SizedBox(height: 8.0),
            
            // НАЗВАНИЕ
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            
            // ЦЕНА
            Text(
              '${widget.product.price} ₽',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            
            // КНОПКА / ПАНЕЛЬ КОЛИЧЕСТВА
            if (!isInCart)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onPressed: () {
                    cart.addToCart(widget.product);
                  },
                  child: const Text(
                    'Добавить в корзину',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (quantity > 1) {
                          // FIX: toString() для int -> String
                          cart.updateQuantity(widget.product.id.toString(), quantity - 1);
                        } else {
                          // FIX: toString() для int -> String
                          cart.removeFromCart(widget.product.id.toString());
                        }
                      },
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (quantity < 10) {
                          // FIX: toString() для int -> String
                          cart.updateQuantity(widget.product.id.toString(), quantity + 1);
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}