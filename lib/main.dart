import 'package:flutter/material.dart';
import 'package:baston_bt_app/pages/inicio_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bastón BT App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const InicioPage(), // <- Aquí cargamos nuestra pantalla de inicio
    );
  }
}
