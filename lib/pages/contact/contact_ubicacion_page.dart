import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ContactUbicacionPage extends StatelessWidget {
  const ContactUbicacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔹 Ejemplo de coordenadas (Babahoyo)
    final LatLng ubicacionUsuario = LatLng(-1.8022, -79.5344);

    return Scaffold(
      appBar: AppBar(title: const Text("Ubicación")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Última ubicación del usuario",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Mapa
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: ubicacionUsuario,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.baston_bt_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ubicacionUsuario,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botón para abrir en Maps
            ElevatedButton.icon(
              onPressed: () {
                // 👉 Aquí puedes integrar url_launcher para abrir Google Maps
              },
              icon: const Icon(Icons.map),
              label: const Text("Abrir en Google Maps"),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
