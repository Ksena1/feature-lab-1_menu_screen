import 'package:flutter/material.dart';
import '../data/mock_products.dart';
import '../widgets/product_card.dart';
import '../widgets/category_tabs.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'Все';

  // Получаем уникальные категории + добавляем "Все"
  List<String> get categories {
    final uniqueCategories = mockProducts.map((product) => product.category).toSet().toList();
    return ['Все', ...uniqueCategories];
  }

  // Фильтруем товары по выбранной категории
  List<Product> get filteredProducts {
    if (selectedCategory == 'Все') {
      return mockProducts;
    }
    return mockProducts.where((product) => product.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню кофейни'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ВЕРХНЯЯ СТРОКА КАТЕГОРИЙ С ПРОКРУТКОЙ
          CategoryTabs(
            categories: categories,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          // СЕТКА ТОВАРОВ В 2 КОЛОНКИ
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // ДВЕ КОЛОНКИ ПО ТЗ
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}