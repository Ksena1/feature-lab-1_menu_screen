import 'package:flutter/material.dart';
import '../data/mock_products.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофейня "Уютная"'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Две колонки как в ТЗ
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7, // Соотношение сторон карточки
        ),
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: mockProducts[index]);
        },
      ),
    );
  }
}