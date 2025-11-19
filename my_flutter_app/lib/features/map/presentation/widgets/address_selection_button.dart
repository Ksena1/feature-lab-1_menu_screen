import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/map/providers/address_provider.dart';
import 'package:my_flutter_app/features/map/presentation/screens/coffee_shop_list_screen.dart';
import 'package:my_flutter_app/features/map/presentation/screens/map_screen.dart';

class AddressSelectionButton extends StatefulWidget {
  const AddressSelectionButton({super.key});

  @override
  State<AddressSelectionButton> createState() => _AddressSelectionButtonState();
}

class _AddressSelectionButtonState extends State<AddressSelectionButton> {
  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Container(
      width: double.infinity, // Максимально доступная ширина
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          _navigateToAddressSelection(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Адрес доставки',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    addressProvider.currentAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // Метод для перехода на экран выбора адреса
  Future<void> _navigateToAddressSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => const CoffeeShopListScreen(),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Выбран адрес: ${result.address}'),
            backgroundColor: Colors.green,
          ),
        );
    }
  }
}