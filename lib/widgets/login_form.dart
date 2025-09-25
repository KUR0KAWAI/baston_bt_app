import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/loading_walking_widget.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onRegisterTap;

  const LoginForm({super.key, required this.onRegisterTap});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> _handleLogin(BuildContext context) async {
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa correo y contraseña"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 🔹 Mostrar loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const LoadingWalkingWidget(message: "Iniciando sesión..."),
    );

    try {
      final user = await AuthService.login(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (mounted) Navigator.pop(context); // cerrar loader

      if (user != null) {
        // ✅ login exitoso → guardado en LocalDb por AuthService
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bienvenido ${user['fullName']}"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        // ❌ credenciales inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Credenciales inválidas"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al iniciar sesión: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        _buildTextField("Correo electrónico", false, emailCtrl),
        const SizedBox(height: 16),
        _buildTextField("Contraseña", true, passCtrl),
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
              onPressed: widget.onRegisterTap,
              child: const Text(
                "Crear una cuenta",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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

  Widget _buildTextField(
      String hint, bool obscure, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
