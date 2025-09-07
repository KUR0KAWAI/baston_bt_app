// lib/pages/dispositivos_page.dart
import 'package:flutter/material.dart';


class DispositivosPage extends StatelessWidget {
  const DispositivosPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Dispositivos')),
      body: const Center(child: Text('Aquí se listarán los dispositivos detectados')),
    );
  }
}