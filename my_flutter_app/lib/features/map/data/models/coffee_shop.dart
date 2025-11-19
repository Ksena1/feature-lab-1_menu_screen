class CoffeeShop {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const CoffeeShop({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'CoffeeShop{id: $id, name: $name, address: $address}';
  }

  // Для сравнения кофеен
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoffeeShop &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}