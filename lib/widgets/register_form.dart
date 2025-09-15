import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterForm({super.key, required this.onLoginTap});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("register_form"),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo + Nombre + Eslogan
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
          "Tu seguridad, tu decisión, tu cuenta.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.bold, // Negrita
            fontStyle: FontStyle.italic, // Cursiva
          ),
        ),

        const SizedBox(height: 24),

        // Campos
        _buildTextField("Nombre completo", false),
        const SizedBox(height: 16),
        _buildTextField("Correo electrónico", false),
        const SizedBox(height: 16),
        _buildTextField("Contraseña", true),
        const SizedBox(height: 16),
        _buildTextField("Confirmar contraseña", true),
        const SizedBox(height: 16),

        // Selector de rol (usuario / contacto) con estilos corregidos
        DropdownButtonFormField<String>(
          value: selectedRole,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.white.withOpacity(0.95),

          // Ítems
          items: const [
            DropdownMenuItem(
              value: "usuario",
              child: Text("Usuario",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            DropdownMenuItem(
              value: "contacto",
              child: Text("Contacto",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ],

          // Cambio de valor
          onChanged: (value) => setState(() => selectedRole = value),

          // Personalización del "hint" y del valor seleccionado
          selectedItemBuilder: (context) {
            return [
              const Text("Usuario",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const Text("Contacto",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ];
          },

          // 👇 Aquí se controla el hint directamente
          hint: const Text(
            "Seleccione tu tipo de cuenta",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),

        const SizedBox(height: 20),

        // Botón Registrar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (selectedRole == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecciona un tipo de cuenta"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              // Envía selectedRole junto con los demás campos al backend
              // Ejemplo: {"nombre": "...", "email": "...", "password": "...", "rol": selectedRole}
              print("Registrado como rol: $selectedRole");
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Registrarse", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 16),

        // Volver a login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Ya tienes cuenta? ",
                style: TextStyle(color: Colors.white70)),
            TextButton(
              onPressed: widget.onLoginTap,
              child: const Text(
                "Inicia sesión",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.80)),
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
