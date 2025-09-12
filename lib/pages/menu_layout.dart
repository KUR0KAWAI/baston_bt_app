// lib/pages/menu_layout.dart
import 'package:flutter/material.dart';
import '../services/db_bootstrap.dart';

// Importa tus páginas reales
import 'inicio_page.dart';
import 'cuidadores_page.dart';
import 'dispositivos_page.dart';
import 'ubicacion_page.dart';
import 'ajustes_page.dart'; // la usaremos como "Ajustes"

class MenuLayout extends StatefulWidget {
  const MenuLayout({super.key});

  @override
  State<MenuLayout> createState() => _MenuLayoutState();
}

class _MenuLayoutState extends State<MenuLayout> {
  int _selectedIndex = 0;

  // Orden: Inicio, Cuidadores, Dispositivos (centrado), Ubicación, Ajustes
  final List<Widget> _pages = const [
    InicioPage(),
    CuidadoresPage(),
    DispositivosPage(),
    UbicacionPage(),
    AjustesPage(), // se muestra como "Ajustes"
  ];

  @override
  void initState() {
    super.initState();
    // Inicializa la BD en background (no modifica tu UI)
    DbBootstrap.init();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tu contenido real, conservando estado por pestaña
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Bottom nav de 5 pestañas (Dispositivos centrado)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Cuidadores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Dispositivos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
