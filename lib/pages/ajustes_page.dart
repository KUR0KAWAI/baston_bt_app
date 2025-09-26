import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Para copiar al portapapeles
import '../services/auth_service.dart';
import '../models/session.dart'; // 👈 Para acceder al usuario logueado
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
    final usuario = Session.currentUser;

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

            // 🔹 Apartado Perfil con flecha desplegable
            ExpansionTile(
              leading: const Icon(Icons.person),
              title: const Text(
                "Perfil",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                ListTile(
                  title: const Text("Usuario:"),
                  subtitle: Text(
                    usuario != null
                        ? "${usuario.nombres} ${usuario.apellidos}"
                        : "Sin nombre",
                  ),
                ),
                ListTile(
                  title: const Text("UUID:"),
                  subtitle: Text(usuario?.id ?? "No disponible"),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      if (usuario?.id.isNotEmpty ?? false) {
                        Clipboard.setData(ClipboardData(text: usuario!.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("UUID copiado")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Botón para cerrar sesión
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
