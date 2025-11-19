import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';

class CoffeeShopRepository {
  // Получить список кофеен
  Future<List<CoffeeShop>> getCoffeeShops() async {
    return _getMockCoffeeShops();
  }

  // Кешировать кофейни (in-memory)
  Future<void> cacheCoffeeShops(List<CoffeeShop> shops) async {
    // In-memory кеширование - просто возвращаем успех
    print('💾 Cached ${shops.length} coffee shops in memory');
  }

  // Получить кешированные кофейни
  Future<List<CoffeeShop>> getCachedCoffeeShops() async {
    return _getMockCoffeeShops();
  }

  // Mock данные кофеен
  List<CoffeeShop> _getMockCoffeeShops() {
    return [
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
    ];
  }
}