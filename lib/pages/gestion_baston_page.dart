// lib/pages/gestion_baston_page.dart
import 'package:flutter/material.dart';


class GestionBastonPage extends StatelessWidget {
  const GestionBastonPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión del Bastón')),
      body: const Center(child: Text('Reportar bastón perdido, configuración, etc.')),
    );
  }
}