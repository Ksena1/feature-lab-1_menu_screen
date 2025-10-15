import '../models/product.dart';

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Капучино',
    price: 180.0,
    imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
    category: 'Кофе',
  ),
  Product(
    id: '2',
    name: 'Латте',
    price: 190.0,
    imageUrl: 'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=300&fit=crop',
    category: 'Кофе',
  ),
  Product(
    id: '3',
    name: 'Эспрессо',
    price: 120.0,
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=300&fit=crop',
    category: 'Кофе',
  ),
  Product(
    id: '4',
    name: 'Американо',
    price: 140.0,
    imageUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=300&fit=crop',
    category: 'Кофе',
  ),
  Product(
    id: '5',
    name: 'Раф кофе',
    price: 210.0,
    imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
    category: 'Кофе',
  ),
  Product(
    id: '6',
    name: 'Чизкейк Нью-Йорк',
    price: 220.0,
    imageUrl: 'https://images.unsplash.com/photo-1578775887804-699de7086ff9?w=400&h=300&fit=crop',
    category: 'Десерты',
  ),
  Product(
    id: '7',
    name: 'Тирамису',
    price: 240.0,
    imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=300&fit=crop',
    category: 'Десерты',
  ),
  Product(
    id: '8',
    name: 'Круассан',
    price: 90.0,
    imageUrl: 'https://images.unsplash.com/photo-1555507032-7d74d756f5c6?w=400&h=300&fit=crop',
    category: 'Выпечка',
  ),
  Product(
    id: '9',
    name: 'Сэндвич с ветчиной',
    price: 160.0,
    imageUrl: 'https://images.unsplash.com/photo-1567234669003-dce7a7a88821?w=400&h=300&fit=crop',
    category: 'Завтраки',
  ),
  Product(
    id: '10',
    name: 'Смузи ягодный',
    price: 190.0,
    imageUrl: 'https://images.unsplash.com/photo-1633409361618-734f5ecebb1c?w=400&h=300&fit=crop',
    category: 'Напитки',
  ),
];

// Получаем уникальные категории
List<String> get categories {
  return mockProducts.map((product) => product.category).toSet().toList();
}