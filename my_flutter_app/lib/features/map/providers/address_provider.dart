import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/features/map/data/models/coffee_shop.dart';

class AddressProvider with ChangeNotifier {
  static const String _selectedAddressKey = 'selected_address';
  
  CoffeeShop? _selectedCoffeeShop;

  CoffeeShop? get selectedCoffeeShop => _selectedCoffeeShop;

  AddressProvider() {
    _loadSelectedAddress();
  }

  // Загрузить сохраненный адрес
  Future<void> _loadSelectedAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressJson = prefs.getString(_selectedAddressKey);
      
      if (addressJson != null) {
        // В реальном приложении здесь был бы парсинг JSON
        // Пока используем mock данные
        _selectedCoffeeShop = CoffeeShop(
          id: '1',
          name: 'Кофейня на Ленина',
          address: 'ул. Ленина, 15',
          latitude: 55.7558,
          longitude: 37.6173,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error loading selected address: $e');
    }
  }

  // Выбрать кофейню
  Future<void> selectCoffeeShop(CoffeeShop coffeeShop) async {
    _selectedCoffeeShop = coffeeShop;
    notifyListeners();
    
    // Сохраняем в SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedAddressKey, coffeeShop.address);
    } catch (e) {
      print('Error saving selected address: $e');
    }
  }

  // Получить текущий адрес для отображения
  String get currentAddress {
    return _selectedCoffeeShop?.address ?? 'Выберите адрес доставки';
  }

  // Очистить выбранный адрес
  Future<void> clearSelectedAddress() async {
    _selectedCoffeeShop = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedAddressKey);
    } catch (e) {
      print('Error clearing selected address: $e');
    }
  }
}