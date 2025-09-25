// lib/pages/ajustes_page.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // 👈 Importamos el servicio de auth
import 'login_page.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    // 🔹 Ejecuta el logout real
    await AuthService.logout();

    // 🔹 Navega al login y elimina todo el historial
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Configuraciones generales",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Botón para cerrar sesión
            ElevatedButton.icon(
              onPressed: () => _cerrarSesion(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Cerrar Sesión",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
