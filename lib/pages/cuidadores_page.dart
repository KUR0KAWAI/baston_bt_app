// lib/pages/cuidadores_page.dart
import 'package:flutter/material.dart';


class CuidadoresPage extends StatelessWidget {
  const CuidadoresPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuidadores')),
      body: const Center(child: Text('Administrar cuidadores')),
    );
  }
}