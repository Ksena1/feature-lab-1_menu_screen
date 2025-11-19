import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/map/providers/address_provider.dart';
import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';
import 'package:my_flutter_app/features/map/data/repositories/in_memory_coffee_shop_repository.dart';
import 'map_screen.dart';  

class CoffeeShopListScreen extends StatefulWidget {
  const CoffeeShopListScreen({super.key});

  @override
  State<CoffeeShopListScreen> createState() => _CoffeeShopListScreenState();
}

class _CoffeeShopListScreenState extends State<CoffeeShopListScreen> {
  final InMemoryCoffeeShopRepository _repository = InMemoryCoffeeShopRepository();
  List<CoffeeShop> _coffeeShops = [];

  @override
  void initState() {
    super.initState();
    _loadCoffeeShops();
  }

  Future<void> _loadCoffeeShops() async {
    final shops = await _repository.getCoffeeShops();
    setState(() {
      _coffeeShops = shops;
    });
  }

  void _selectCoffeeShop(CoffeeShop shop, BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.selectCoffeeShop(shop);
    Navigator.pop(context, shop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Наши кофейни'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _coffeeShops.length,
        itemBuilder: (context, index) {
          final shop = _coffeeShops[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.local_cafe, color: Colors.brown),
              title: Text(
                shop.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(shop.address),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectCoffeeShop(shop, context),
            ),
          );
        },
      ),
    );
  }
}