import 'package:my_flutter_app/features/map/data/database/app_database.dart';
import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';

class CoffeeShopRepository {
  final AppDatabase _database;

  CoffeeShopRepository(this._database);

  // Получить список кофеен (в будущем можно добавить сетевой источник)
  Future<List<CoffeeShop>> getCoffeeShops() async {
    // Пока возвращаем mock данные
    return _getMockCoffeeShops();
  }

  // Кешировать кофейни в базу данных
  Future<void> cacheCoffeeShops(List<CoffeeShop> shops) async {
    final dbShops = shops.map((shop) => CoffeeShopDb(
      id: shop.id,
      name: shop.name,
      address: shop.address,
      latitude: shop.latitude,
      longitude: shop.longitude,
    )).toList();

    await _database.cacheCoffeeShops(dbShops);
  }

  // Получить кешированные кофейни из базы
  Future<List<CoffeeShop>> getCachedCoffeeShops() async {
    final dbShops = await _database.getCachedCoffeeShops();
    return dbShops.map((dbShop) => CoffeeShop(
      id: dbShop.id,
      name: dbShop.name,
      address: dbShop.address,
      latitude: dbShop.latitude,
      longitude: dbShop.longitude,
    )).toList();
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