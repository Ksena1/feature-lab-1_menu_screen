import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофейня',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}