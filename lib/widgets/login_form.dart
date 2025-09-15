import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/loading_walking_widget.dart'; // 👈 importa tu loader

class LoginForm extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const LoginForm({super.key, required this.onRegisterTap});

  Future<void> _handleLogin(BuildContext context) async {
    // Mostrar loader
    showDialog(
      context: context,
      barrierDismissible: false, // no se cierra al tocar afuera
      builder: (context) =>
      const LoadingWalkingWidget(message: "Iniciando sesión..."),
    );

    // Simular tiempo de espera mínimo de 3 segundos
    await Future.delayed(const Duration(seconds: 3));

    // 👉 Aquí podrías poner la lógica real de login (API, DB, etc.)
    // Por ahora, asumimos que es correcto y cerramos el loader

    Navigator.pop(context); // Cierra el loader
    Navigator.pushReplacementNamed(context, '/menu'); // Ir al menú
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("login"),
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Logo + Nombre + Eslogan
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", height: 40),
                const SizedBox(width: 10),
                const Text(
                  "PathSense",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              "Tu camino, tu seguridad, tu independencia.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),

        // Campos
        _buildTextField("Correo electrónico", false),
        const SizedBox(height: 16),
        _buildTextField("Contraseña", true),
        const SizedBox(height: 20),

        // Botón Entrar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleLogin(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Entrar", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 16),

        // Crear cuenta
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes cuenta? ",
                style: TextStyle(color: Colors.white70)),
            TextButton(
              onPressed: onRegisterTap,
              child: const Text(
                "Crear una cuenta",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Conoce el acuerdo de licencia de usuario",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, bool obscure) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
