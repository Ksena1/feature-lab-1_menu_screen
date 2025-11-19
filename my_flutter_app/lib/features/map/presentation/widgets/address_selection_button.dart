import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/map/providers/address_provider.dart';

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
    // TODO: Заменить на реальный экран выбора адреса
    final result = await Navigator.push(
      context,
      MaterialPageRoute<String>(
        builder: (context) => const _TempAddressSelectionScreen(),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Выбран адрес: $result')));
    }
  }
}

// Временный экран выбора адреса (заменим позже на реальный)
class _TempAddressSelectionScreen extends StatelessWidget {
  const _TempAddressSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите адрес')),
      body: ListView(
        children: [
          _buildAddressItem('ул. Ленина, 15', context),
          _buildAddressItem('ул. Пушкина, 10', context),
          _buildAddressItem('ул. Гагарина, 25', context),
        ],
      ),
    );
  }

  Widget _buildAddressItem(String address, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.brown),
        title: Text(address),
        onTap: () {
          Navigator.pop(context, address);
        },
      ),
    );
  }
}