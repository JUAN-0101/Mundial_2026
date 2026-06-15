import 'package:flutter/material.dart';
import 'screens/menu_principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mundial 2026',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const MenuPrincipal(),
    );
  }
}
