import '../models/product.dart';

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Капучино',
    price: 180.0,
    imageUrl: 'assets/images/cappuccino.jpg',
    category: 'Кофе',
  ),
  Product(
    id: '2',
    name: 'Латте',
    price: 190.0,
    imageUrl: 'assets/images/latte.jpg',
    category: 'Кофе',
  ),
  Product(
    id: '3',
    name: 'Эспрессо',
    price: 120.0,
    imageUrl: 'assets/images/espresso.jpg',
    category: 'Кофе',
  ),
  Product(
    id: '4',
    name: 'Американо',
    price: 140.0,
    imageUrl: 'assets/images/americano.jpg',
    category: 'Кофе',
  ),
  Product(
    id: '5',
    name: 'Раф кофе',
    price: 210.0,
    imageUrl: 'assets/images/raf_coffee.jpg',
    category: 'Кофе',
  ),
  Product(
    id: '6',
    name: 'Чизкейк Нью-Йорк',
    price: 220.0,
    imageUrl: 'assets/images/cheesecake.jpg',
    category: 'Десерты',
  ),
  Product(
    id: '7',
    name: 'Тирамису',
    price: 240.0,
    imageUrl: 'assets/images/tiramisu.jpg',
    category: 'Десерты',
  ),
  Product(
    id: '8',
    name: 'Круассан',
    price: 90.0,
    imageUrl: 'assets/images/croissant.jpg',
    category: 'Выпечка',
  ),
  Product(
    id: '9',
    name: 'Сэндвич с ветчиной',
    price: 160.0,
    imageUrl: 'assets/images/sandwich.jpg',
    category: 'Завтраки',
  ),
  Product(
    id: '10',
    name: 'Смузи ягодный',
    price: 190.0,
    imageUrl: 'assets/images/smoothie.jpg',
    category: 'Напитки',
  ),
  Product(
    id: '11',
    name: 'Чай Эрл Грей',
    price: 150.0,
    imageUrl: 'assets/images/earl_grey.jpg',
    category: 'Чай',
  ),
  Product(
    id: '12',
    name: 'Зеленый чай',
    price: 140.0,
    imageUrl: 'assets/images/green_tea.jpg',
    category: 'Чай',
  ),
  Product(
    id: '13',
    name: 'Чай с мятой',
    price: 160.0,
    imageUrl: 'assets/images/mint_tea.jpg',
    category: 'Чай',
  ),
  Product(
    id: '14',
    name: 'Фруктовый чай',
    price: 170.0,
    imageUrl: 'assets/images/fruit_tea.jpg',
    category: 'Чай',
  ),
];

List<String> get categories {
  return mockProducts.map((product) => product.category).toSet().toList();
}