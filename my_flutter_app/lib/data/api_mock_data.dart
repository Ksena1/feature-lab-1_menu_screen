import '../models/product.dart';
import '../models/category.dart';

// Временные моковые данные для тестирования, пока не работает API
class ApiMockData {
  static final List<Category> mockCategories = [
    Category(id: 1, name: 'Кофе'),
    Category(id: 2, name: 'Чай'),
    Category(id: 3, name: 'Десерты'),
    Category(id: 4, name: 'Выпечка'),
    Category(id: 5, name: 'Завтраки'),
    Category(id: 6, name: 'Напитки'),
  ];

  static final List<Product> mockProducts = [
    Product(
      id: 1,
      name: 'Капучино',
      price: 180,
      category: 'Кофе',
      categoryId: 1,
      imageUrl: 'assets/images/cappuccino.jpg',
    ),
    Product(
      id: 2,
      name: 'Латте',
      price: 190,
      category: 'Кофе',
      categoryId: 1,
      imageUrl: 'assets/images/latte.jpg',
    ),
    Product(
      id: 3,
      name: 'Эспрессо',
      price: 150,
      category: 'Кофе',
      categoryId: 1,
      imageUrl: 'assets/images/espresso.jpg',
    ),
    Product(
      id: 4,
      name: 'Американо',
      price: 160,
      category: 'Кофе',
      categoryId: 1,
      imageUrl: 'assets/images/americano.jpg',
    ),
    Product(
      id: 5,
      name: 'Раф-кофе',
      price: 220,
      category: 'Кофе',
      categoryId: 1,
      imageUrl: 'assets/images/raf_coffee.jpg',
    ),
    Product(
      id: 6,
      name: 'Чизкейк',
      price: 250,
      category: 'Десерты',
      categoryId: 3,
      imageUrl: 'assets/images/cheesecake.jpg',
    ),
    Product(
      id: 7,
      name: 'Тирамису',
      price: 280,
      category: 'Десерты',
      categoryId: 3,
      imageUrl: 'assets/images/tiramisu.jpg',
    ),
    Product(
      id: 8,
      name: 'Круассан',
      price: 120,
      category: 'Выпечка',
      categoryId: 4,
      imageUrl: 'assets/images/croissant.jpg',
    ),
    Product(
      id: 9,
      name: 'Сэндвич',
      price: 200,
      category: 'Завтраки',
      categoryId: 5,
      imageUrl: 'assets/images/sandwich.jpg',
    ),
    Product(
      id: 10,
      name: 'Смузи',
      price: 180,
      category: 'Напитки',
      categoryId: 6,
      imageUrl: 'assets/images/smoothie.jpg',
    ),
    Product(
      id: 11,
      name: 'Эрл Грей',
      price: 150,
      category: 'Чай',
      categoryId: 2,
      imageUrl: 'assets/images/earl_grey.jpg',
    ),
    Product(
      id: 12,
      name: 'Зеленый чай',
      price: 140,
      category: 'Чай',
      categoryId: 2,
      imageUrl: 'assets/images/green_tea.jpg',
    ),
    Product(
      id: 13,
      name: 'Мятный чай',
      price: 160,
      category: 'Чай',
      categoryId: 2,
      imageUrl: 'assets/images/mint_tea.jpg',
    ),
    Product(
      id: 14,
      name: 'Фруктовый чай',
      price: 170,
      category: 'Чай',
      categoryId: 2,
      imageUrl: 'assets/images/fruit_tea.jpg',
    ),
  ];
}