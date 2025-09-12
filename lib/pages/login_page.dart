import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔹 Fondo con imagen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/FondoLogin.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width < 400
                      ? MediaQuery.of(context).size.width * 0.9
                      : 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Logo + Nombre + Eslogan
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                height: 40, // 👈 ajusta tamaño del logo
                              ),
                              const SizedBox(width: 10), // espacio entre logo y texto
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
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Campo correo
                      _buildTextField("Correo electrónico", false),
                      const SizedBox(height: 16),

                      // Campo contraseña
                      _buildTextField("Contraseña", true),
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Botón Entrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/menu');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Entrar",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Texto con línea
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white.withOpacity(0.6))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "O ingresa con",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white.withOpacity(0.6))),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botones sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.g_mobiledata),
                          const SizedBox(width: 16),
                          _socialButton(Icons.apple),
                          const SizedBox(width: 16),
                          _socialButton(Icons.close),
                        ],
                      ),
                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Conoce el acuerdo de licencia de usuario",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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

  Widget _socialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
