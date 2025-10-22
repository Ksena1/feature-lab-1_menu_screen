import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/menu_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Кофейня "Уютная"',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6F4E37),
            primary: const Color(0xFF6F4E37),
            secondary: const Color(0xFFA67B5B),
            surface: const Color(0xFFFAF8F5),
            background: const Color(0xFFFAF8F5),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6F4E37),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          // УБИРАЕМ cardTheme полностью - он не обязателен
          useMaterial3: true,
        ),
        home: const MenuScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}