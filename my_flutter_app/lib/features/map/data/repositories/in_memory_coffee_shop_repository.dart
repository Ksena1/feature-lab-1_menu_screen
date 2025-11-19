import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';

class InMemoryCoffeeShopRepository {
  // In-memory хранилище вместо SQLite
  final List<CoffeeShop> _coffeeShops = [];

  InMemoryCoffeeShopRepository() {
    _initializeMockData();
  }

  // Получить список кофеен
  Future<List<CoffeeShop>> getCoffeeShops() async {
    return List.from(_coffeeShops);
  }

  // Кешировать кофейни (просто сохраняем в память)
  Future<void> cacheCoffeeShops(List<CoffeeShop> shops) async {
    _coffeeShops.clear();
    _coffeeShops.addAll(shops);
  }

  // Получить кешированные кофейни
  Future<List<CoffeeShop>> getCachedCoffeeShops() async {
    return List.from(_coffeeShops);
  }

  // Инициализация mock данных
  void _initializeMockData() {
    _coffeeShops.addAll([
      CoffeeShop(
        id: '1',
        name: 'Кофейня на Ленина',
        address: 'ул. Ленина, 15',
        latitude: 55.7558,
        longitude: 37.6173,
      ),
      CoffeeShop(
        id: '2', 
        name: 'Кофейня на Пушкина',
        address: 'ул. Пушкина, 10',
        latitude: 55.7604,
        longitude: 37.6184,
      ),
      CoffeeShop(
        id: '3',
        name: 'Кофейня на Гагарина', 
        address: 'ул. Гагарина, 25',
        latitude: 55.7500,
        longitude: 37.6200,
      ),
    ]);
  }
}