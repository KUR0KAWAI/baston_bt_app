import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InicioPage extends StatelessWidget {
  final String rol; // "usuario" o "confianza"

  const InicioPage({
    super.key,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    // ⚠️ Nombre fijo por ahora
    const String nombre = "Moi";

    // 🎨 Obtenemos colores desde el tema
    final theme = Theme.of(context);

    final String titulo;
    final String mensaje;
    final IconData icono;
    final Color color;

    if (rol == "usuario") {
      titulo = "Bienvenido $nombre";
      mensaje =
      "Gracias por confiar en PathSense.\n\nDesde aquí podrás gestionar tus dispositivos, tus contactos de confianza y configurar zonas seguras para tu tranquilidad.";
      icono = Icons.person_pin_circle;
      color = theme.colorScheme.primary; // 👈 usa color primario
    } else {
      titulo = "Hola $nombre";
      mensaje =
      "Eres un contacto de confianza.\n\nPodrás recibir notificaciones, apoyar en situaciones de emergencia y mantener la seguridad del familiar o amigo/a que acompañas.";
      icono = Icons.verified_user;
      color = theme.colorScheme.secondary; // 👈 usa color secundario
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // 🔹 Logo + Nombre + Slogan
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PathSense',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tu camino, tu seguridad, tu independencia.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔹 Tarjeta de bienvenida según rol
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(icono, size: 60, color: color),
                      const SizedBox(height: 16),
                      Text(
                        titulo,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mensaje,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: theme.textTheme.bodyLarge?.color,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
