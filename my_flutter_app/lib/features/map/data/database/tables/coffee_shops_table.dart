import 'package:drift/drift.dart';

@DataClassName('CoffeeShopDb')
class CoffeeShops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  
  @override
  Set<Column> get primaryKey => {id};
}