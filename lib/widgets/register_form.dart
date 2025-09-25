import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/loading_walking_widget.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterForm({super.key, required this.onLoginTap});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  String? selectedRole;

  Future<void> _handleRegister() async {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passCtrl.text.isEmpty ||
        confirmCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 🔹 Validación de longitud mínima
    if (passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La contraseña debe tener mínimo 6 caracteres"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (passCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona un tipo de cuenta"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 🔹 Normalizar rol ("Usuario" → "usuario", "Contacto" → "contacto")
    final rol = selectedRole!.toLowerCase();

    // 🔹 Mostrar loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
      const LoadingWalkingWidget(message: "Creando cuenta..."),
    );

    final ok = await AuthService.register(
      emailCtrl.text.trim(),
      passCtrl.text,
      nameCtrl.text.trim(),
      rol,
    );

    if (mounted) Navigator.pop(context); // cerrar loader

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Registro exitoso, ahora inicia sesión"),
          backgroundColor: Colors.green,
        ),
      );
      widget.onLoginTap(); // volver a login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Error al registrar usuario"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),

        // Campos
        _buildTextField("Nombre completo", false, nameCtrl),
        const SizedBox(height: 16),
        _buildTextField("Correo electrónico", false, emailCtrl),
        const SizedBox(height: 16),
        _buildTextField("Contraseña", true, passCtrl),
        const SizedBox(height: 16),
        _buildTextField("Confirmar contraseña", true, confirmCtrl),
        const SizedBox(height: 16),

        // Selector de rol
        DropdownButtonFormField<String>(
          value: selectedRole,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.white.withOpacity(0.95),
          items: const [
            DropdownMenuItem(
              value: "Usuario",
              child: Text("Usuario",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            DropdownMenuItem(
              value: "Contacto",
              child: Text("Contacto",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ],
          onChanged: (value) => setState(() => selectedRole = value),
          selectedItemBuilder: (context) {
            return [
              const Text("Usuario",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const Text("Contacto",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ];
          },
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
        ),

        const SizedBox(height: 20),

        // Botón Registrar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleRegister,
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

  Widget _buildTextField(
      String hint, bool obscure, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
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
