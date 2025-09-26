import 'package:flutter/material.dart';
import '../services/db_bootstrap.dart';
import '../models/session.dart'; // 👈 Importamos la sesión

// Importa tus páginas de usuario
import 'user/user_confianza_page.dart';
import 'user/user_dispositivos_page.dart';
import 'user/user_ubicacion_page.dart';

// Importa tus páginas de contacto
import 'contact/contact_confianza_page.dart';
import 'contact/contact_ubicacion_page.dart';

// Comunes
import 'inicio_page.dart';
import 'ajustes_page.dart';

class MenuLayout extends StatefulWidget {
  const MenuLayout({super.key});

  @override
  State<MenuLayout> createState() => _MenuLayoutState();
}

class _MenuLayoutState extends State<MenuLayout> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _items;

  @override
  void initState() {
    super.initState();

    // Inicializa la BD en background
    DbBootstrap.init();

    // 🔹 Obtenemos el rol desde la sesión (normalizado a minúsculas)
    final rol = (Session.currentUser?.rol ?? "Usuario").toLowerCase();

    if (rol == "usuario") {
      // Menú del Usuario
      _pages = const [
        InicioPage(),
        UserConfianzaPage(),
        UserDispositivosPage(),
        UserUbicacionPage(),
        AjustesPage(),
      ];
      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'Confianza'),
        BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'Dispositivos'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Ubicación'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ];
    } else if (rol == "contacto") {
      // Menú del Contacto
      _pages = const [
        InicioPage(),
        ContactConfianzaPage(),
        ContactUbicacionPage(),
        AjustesPage(),
      ];
      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Confianza'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Ubicación'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ];
    } else {
      // 🔹 Fallback si el rol no es válido (carga menú básico)
      _pages = const [InicioPage(), AjustesPage()];
      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        items: _items,
      ),
    );
  }
}
