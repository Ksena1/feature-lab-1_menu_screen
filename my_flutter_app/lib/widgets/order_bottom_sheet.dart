import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart.dart';

class OrderBottomSheet extends StatefulWidget {
  final CartProvider cartProvider;

  const OrderBottomSheet({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  bool _isSubmitting = false;

  void _submitOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.cartProvider.submitOrder();
      
      // Успешный заказ
      widget.cartProvider.clearCart();
      Navigator.of(context).pop();
      
      // SnackBar об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заказ успешно оформлен!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // SnackBar об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка оформления заказа: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearCartAndClose() {
    widget.cartProvider.clearCart();
    Navigator.of(context).pop();
  }

  // Метод для отображения каждой позиции отдельно если количество > 1
  List<Widget> _buildOrderItems() {
    final List<Widget> items = [];
    
    for (final item in widget.cartProvider.items) {
      if (item.quantity == 1) {
        // Одна позиция
        items.add(_buildOrderItem(item));
      } else {
        // Несколько одинаковых позиций
        for (int i = 0; i < item.quantity; i++) {
          items.add(_buildOrderItem(item, showQuantity: false));
        }
      }
    }
    
    return items;
  }

  Widget _buildOrderItem(CartItem item, {bool showQuantity = true}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: item.imageUrl != null
            ? Image.asset(
                item.imageUrl!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.fastfood,
                color: Colors.grey[400],
              ),
      ),
      title: Text(item.name),
      subtitle: showQuantity 
          ? Text('${item.price} ₽ × ${item.quantity}')
          : Text('${item.price} ₽'),
      trailing: Text(
        showQuantity ? '${item.totalPrice} ₽' : '${item.price} ₽',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ваш заказ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Список товаров в заказе
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _buildOrderItems(),
              ),
            ),
          ),
          
          // Итого
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Итого:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.cartProvider.totalPrice} ₽',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearCartAndClose,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Очистить корзину'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Оформить заказ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}