import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactConfianzaPage extends StatelessWidget {
  const ContactConfianzaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Confianza")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildCard(Icons.notifications_active, "Alertas", theme),
            _buildCard(Icons.bluetooth_connected, "Estado bastón", theme),
            _buildCard(Icons.phone, "Llamar", theme),
            _buildCard(Icons.chat_bubble, "Mensajes", theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // 👉 Aquí defines la navegación o acción
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
