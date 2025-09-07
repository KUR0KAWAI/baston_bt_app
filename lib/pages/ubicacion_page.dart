// lib/pages/ubicacion_page.dart
import 'package:flutter/material.dart';


class UbicacionPage extends StatelessWidget {
  const UbicacionPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación')),
      body: const Center(child: Text('Zonas seguras, mapa y registros de ubicación')),
    );
  }
}