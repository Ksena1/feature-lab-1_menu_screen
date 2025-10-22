import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import '../data/mock_products.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  String _activeCategory = '';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    
    _categories = _getUniqueCategories();
    _activeCategory = _categories.isNotEmpty ? _categories.first : '';
    
    for (var category in _categories) {
      _categoryKeys[category] = GlobalKey();
    }
    
    _productScrollController.addListener(_handleProductScroll);
  }

  @override
  void dispose() {
    _productScrollController.removeListener(_handleProductScroll);
    _productScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  List<String> _getUniqueCategories() {
    final categories = mockProducts.map((product) => product.category).toSet().toList();
    return categories..sort();
  }

  List<Product> _getProductsByCategory(String category) {
    return mockProducts.where((product) => product.category == category).toList();
  }

  void _handleProductScroll() {
    final scrollPosition = _productScrollController.offset;
    var newActiveCategory = _activeCategory;
    double closestDistance = double.infinity;

    for (var category in _categories) {
      final key = _categoryKeys[category];
      if (key?.currentContext != null) {
        final box = key?.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final distance = position.dy.abs(); 
          
          if (distance < closestDistance && position.dy < 200) {
            closestDistance = distance;
            newActiveCategory = category;
          }
        }
      }
    }

    if (newActiveCategory == _activeCategory && 
        _productScrollController.position.pixels >= 
        _productScrollController.position.maxScrollExtent - 100) {
      newActiveCategory = _categories.last;
    }

    if (newActiveCategory != _activeCategory) {
      setState(() {
        _activeCategory = newActiveCategory;
      });
    }
  }

  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _activeCategory = category;
    });
    _scrollToCategory(category);
  }

  void _openCartScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalItems = cartProvider.totalItems;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CategoryTabs(
                categories: _categories,
                activeCategory: _activeCategory,
                onCategorySelected: _onCategorySelected,
                scrollController: _categoryScrollController,
              ),
              Expanded(
                child: ListView(
                  controller: _productScrollController,
                  children: _categories.map((category) {
                    final products = _getProductsByCategory(category);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          child: Text(
                            category,
                            key: _categoryKeys[category],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: products[index]);
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _openCartScreen(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: Badge(
                label: Text(
                  totalItems.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
    );
  }
}