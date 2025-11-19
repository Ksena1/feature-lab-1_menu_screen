import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/map/providers/address_provider.dart';
import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';
import 'package:my_flutter_app/features/map/data/repositories/in_memory_coffee_shop_repository.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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

  void _showCoffeeShopBottomSheet(CoffeeShop shop) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shop.address,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
                    addressProvider.selectCoffeeShop(shop);
                    Navigator.pop(context); // Закрыть BottomSheet
                    Navigator.pop(context, shop); // Вернуться на предыдущий экран
                  },
                  child: const Text('Выбрать'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите кофейню на карте'),
      ),
      body: _buildMapPlaceholder(),
    );
  }

  // Заглушка для карты (пока нет реальной интеграции с Yandex Mapkit)
  Widget _buildMapPlaceholder() {
    return Stack(
      children: [
        // Заглушка карты
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Карта кофеен',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_coffeeShops.length} кофеен поблизости',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        
        // Маркеры кофеен (заглушки)
        ..._coffeeShops.map((shop) {
          return Positioned(
            left: 100 + (_coffeeShops.indexOf(shop) * 80),
            top: 200 + (_coffeeShops.indexOf(shop) * 40),
            child: GestureDetector(
              onTap: () => _showCoffeeShopBottomSheet(shop),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.local_cafe, color: Colors.white, size: 20),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
