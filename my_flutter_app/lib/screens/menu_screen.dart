import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import '../widgets/order_bottom_sheet.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  final ApiService _apiService = ApiService();
  
  String _activeCategory = '';
  List<Category> _categories = [];
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _productScrollController.removeListener(_handleProductScroll);
    _productScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final categories = await _apiService.getCategories();
      final productsResponse = await _apiService.getProducts();
      
      setState(() {
        _categories = categories;
        _products = productsResponse.products;
        _activeCategory = _categories.isNotEmpty ? _categories.first.name : '';
        
        // Создаем ключи для каждой категории
        for (var category in _categories) {
          _categoryKeys[category.name] = GlobalKey();
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки данных: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    
    _productScrollController.addListener(_handleProductScroll);
  }

  void _handleProductScroll() {
    final scrollPosition = _productScrollController.offset;
    var newActiveCategory = _activeCategory;
    double closestDistance = double.infinity;

    for (var category in _categories) {
      final key = _categoryKeys[category.name];
      if (key?.currentContext != null) {
        final box = key?.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final distance = position.dy.abs();
          
          if (distance < closestDistance && position.dy < 200) {
            closestDistance = distance;
            newActiveCategory = category.name;
          }
        }
      }
    }

    if (newActiveCategory == _activeCategory && 
        _productScrollController.position.pixels >= 
        _productScrollController.position.maxScrollExtent - 100) {
      newActiveCategory = _categories.isNotEmpty ? _categories.last.name : '';
    }

    if (newActiveCategory != _activeCategory) {
      setState(() {
        _activeCategory = newActiveCategory;
      });
    }
  }

  void _scrollToCategory(String categoryName) {
    final key = _categoryKeys[categoryName];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      _activeCategory = categoryName;
    });
    _scrollToCategory(categoryName);
  }

  void _openCartScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return OrderBottomSheet(cartProvider: Provider.of<CartProvider>(context, listen: false));
      },
    );
  }

  List<Product> _getProductsByCategory(String categoryName) {
    return _products.where((product) => product.category == categoryName).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalItems = cartProvider.totalItems;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CategoryTabs(
                categories: _categories.map((c) => c.name).toList(),
                activeCategory: _activeCategory,
                onCategorySelected: _onCategorySelected,
                scrollController: _categoryScrollController,
              ),
              Expanded(
                child: ListView(
                  controller: _productScrollController,
                  children: _categories.map((category) {
                    final products = _getProductsByCategory(category.name);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          child: Text(
                            category.name,
                            key: _categoryKeys[category.name],
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
          // Кнопка корзины появляется только если есть товары
          if (totalItems > 0)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _openCartScreen(context),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      '${cartProvider.totalPrice} ₽',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}