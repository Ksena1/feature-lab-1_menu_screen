import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// ДОБАВЬТЕ ЭТОТ ИМПОРТ:
import 'tables/coffee_shops_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CoffeeShops])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Очистить все кешированные кофейни
  Future<void> clearCoffeeShops() async {
    await delete(coffeeShops).go();
  }

  // Кешировать список кофеен
  Future<void> cacheCoffeeShops(List<CoffeeShopDb> shops) async {
    await batch((batch) {
      batch.insertAll(coffeeShops, shops, mode: InsertMode.insertOrReplace);
    });
  }

  // Получить все кешированные кофейни
  Future<List<CoffeeShopDb>> getCachedCoffeeShops() async {
    return await select(coffeeShops).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'coffee_shops.db'));
    return NativeDatabase(file);
  });
}