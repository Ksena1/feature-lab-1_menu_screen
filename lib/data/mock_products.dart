import '../models/product.dart';

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Капучино',
    price: 180.0,
    category: 'Кофе',
  ),
  Product(
    id: '2',
    name: 'Латте',
    price: 190.0,
    category: 'Кофе',
  ),
  Product(
    id: '3',
    name: 'Эспрессо',
    price: 120.0,
    category: 'Кофе',
  ),
  Product(
    id: '4',
    name: 'Американо',
    price: 140.0,
    category: 'Кофе',
  ),
  Product(
    id: '5',
    name: 'Раф кофе',
    price: 210.0,
    category: 'Кофе',
  ),
  Product(
    id: '6',
    name: 'Чизкейк Нью-Йорк',
    price: 220.0,
    category: 'Десерты',
  ),
  Product(
    id: '7',
    name: 'Тирамису',
    price: 240.0,
    category: 'Десерты',
  ),
  Product(
    id: '8',
    name: 'Круассан',
    price: 90.0,
    category: 'Выпечка',
  ),
  Product(
    id: '9',
    name: 'Сэндвич с ветчиной',
    price: 160.0,
    category: 'Завтраки',
  ),
  Product(
    id: '10',
    name: 'Смузи ягодный',
    price: 190.0,
    category: 'Напитки',
  ),
];

// Получаем уникальные категории
List<String> get categories {
  return mockProducts.map((product) => product.category).toSet().toList();
}