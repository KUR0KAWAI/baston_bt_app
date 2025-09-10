import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40), // más arriba

              // Logo + texto horizontal, más grande y con expansión
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo expandido proporcionalmente
                  Flexible(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 1, // Mantiene proporción cuadrada
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Título + Slogan
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PathSense',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tu camino, tu seguridad, tu independencia.',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Mensaje de bienvenida
              const Text(
                'Bienvenido a PathSense, una aplicación pensada para ayudarte a mantener el control y la seguridad de tu camino.\n\nDesde aquí puedes gestionar tus dispositivos, cuidadores y zonas seguras.',
                style: TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
