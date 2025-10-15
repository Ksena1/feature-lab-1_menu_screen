import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isInCart = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        // ТОЧНЫЕ ОТСТУПЫ ПО ТЗ: vertical 16px, horizontal 32px
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // КАРТИНКА: высота 100px, ширина автоматически
            Container(
              height: 100.0, // ТОЧНО 100px ПО ТЗ
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: widget.product.imageUrl != null
                  ? Image.network(
                      widget.product.imageUrl!,
                      fit: BoxFit.contain, // Не обрезается, вся видна
                    )
                  : Icon(
                      _getProductIcon(),
                      size: 40,
                      color: Colors.grey[500],
                    ),
            ),
            // ОТСТУП 8px МЕЖДУ КОМПОНЕНТАМИ
            const SizedBox(height: 8.0),
            
            // НАЗВАНИЕ ТОВАРА
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            
            // ЦЕНА
            Text(
              '${widget.product.price} ₽',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            
            // КНОПКА / ПАНЕЛЬ КОЛИЧЕСТВА
            if (!isInCart)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isInCart = true;
                      quantity = 1;
                    });
                  },
                  child: const Text('Купить'),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          } else {
                            isInCart = false; // Убираем из корзины при 1
                          }
                        });
                      },
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () {
                        setState(() {
                          if (quantity < 10) { // ВЕРХНИЙ ЛИМИТ 10
                            quantity++;
                          }
                        });
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
      default:
        return Icons.local_cafe;
    }
  }
}