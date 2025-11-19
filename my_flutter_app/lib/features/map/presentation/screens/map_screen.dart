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
  double _zoom = 1.0;
  Offset _position = Offset.zero;
  Offset? _startPan;

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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 220,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_cafe, color: Colors.brown),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shop.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final addressProvider = Provider.of<AddressProvider>(context, listen: false);
                          addressProvider.selectCoffeeShop(shop);
                          Navigator.pop(context); // Закрыть BottomSheet
                          Navigator.pop(context, shop); // Вернуться на предыдущий экран
                        },
                        child: const Text(
                          'Выбрать эту кофейню',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startPan = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      setState(() {
        _zoom = (_zoom * details.scale).clamp(0.5, 3.0);
      });
    }
    
    if (details.focalPoint != _startPan) {
      setState(() {
        _position += details.focalPoint - _startPan!;
        _startPan = details.focalPoint;
      });
    }
  }

  void _resetMap() {
    setState(() {
      _zoom = 1.0;
      _position = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта кофеен'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _resetMap,
            tooltip: 'Вернуть к центру',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Фон карты с узором
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[50]!,
                  Colors.green[50]!,
                ],
              ),
            ),
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Transform.translate(
                offset: _position,
                child: Transform.scale(
                  scale: _zoom,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _MapPainter(),
                  ),
                ),
              ),
            ),
          ),
          
          // Маркеры кофеен
          ..._coffeeShops.asMap().entries.map((entry) {
            final index = entry.key;
            final shop = entry.value;
            final markerPosition = _getMarkerPosition(index);
            
            return Positioned(
              left: markerPosition.dx + _position.dx,
              top: markerPosition.dy + _position.dy,
              child: Transform.scale(
                scale: _zoom,
                child: _CoffeeShopMarker(
                  shop: shop,
                  onTap: () => _showCoffeeShopBottomSheet(shop),
                ),
              ),
            );
          }).toList(),
          
          // Легенда карты
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Наши кофейни',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Offset _getMarkerPosition(int index) {
    const double baseX = 150;
    const double baseY = 150;
    const double spacing = 120;
    
    switch (index) {
      case 0:
        return Offset(baseX, baseY);
      case 1:
        return Offset(baseX + spacing, baseY - spacing * 0.5);
      case 2:
        return Offset(baseX - spacing * 0.7, baseY + spacing * 0.8);
      default:
        return Offset(baseX + (index * 80), baseY + (index % 2 == 0 ? 60 : -60));
    }
  }
}

// Кастомный маркер кофейни
class _CoffeeShopMarker extends StatelessWidget {
  final CoffeeShop shop;
  final VoidCallback onTap;

  const _CoffeeShopMarker({
    required this.shop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            // Тень маркера
            Positioned(
              bottom: 2,
              left: 8,
              child: Container(
                width: 34,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
            // Основной маркер
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.brown,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_cafe,
                color: Colors.white,
                size: 20,
              ),
            ),
            // Эффект пульсации
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.brown.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Кастомный painter для рисования карты
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    final roadPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final buildingPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    // Рисуем "водоемы"
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.1, 200, 150),
      paint..color = Colors.blue[200]!,
    );

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.6, 150, 120),
      paint..color = Colors.blue[200]!,
    );

    // Рисуем "дороги"
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.3),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.9),
      roadPaint,
    );

    // Рисуем "здания"
    for (int i = 0; i < 8; i++) {
      final x = (i % 4) * 100.0 + 50;
      final y = (i ~/ 4) * 120.0 + 80;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, 60, 40),
        buildingPaint,
      );
      
      // Окна в зданиях
      for (int j = 0; j < 4; j++) {
        canvas.drawRect(
          Rect.fromLTWH(x + 10 + (j % 2) * 20, y + 10 + (j ~/ 2) * 15, 8, 8),
          Paint()..color = Colors.yellow[700]!,
        );
      }
    }

    // Рисуем "парки"
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.5, 180, 120),
      Paint()..color = Colors.green[200]!,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}