import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../models/zona_segura.dart';

class MapaWidget extends StatelessWidget {
  final LatLng? ubicacionActual;
  final List<LatLng> recorrido;
  final List<ZonaSegura> zonasSeguras;
  final Function(LatLng) onTapMapa;
  final bool bastonConectado;

  const MapaWidget({
    super.key,
    required this.ubicacionActual,
    required this.recorrido,
    required this.zonasSeguras,
    required this.onTapMapa,
    required this.bastonConectado,
  });

  @override
  Widget build(BuildContext context) {
    if (!bastonConectado) {
      return const Center(
        child: Text(
          "⚠️ No hay conexión con el bastón.\nConéctalo para recibir ubicación.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    if (ubicacionActual == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: ubicacionActual!,
          initialZoom: 16,
          onTap: (tapPosition, latlng) => onTapMapa(latlng),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.baston_bt_app",
          ),
          // 📍 Ubicación actual → ICONO ROJO
          MarkerLayer(
            markers: [
              Marker(
                point: ubicacionActual!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on, // 👈 mismo icono
                  color: Colors.red,  // 🔴 en rojo
                  size: 40,
                ),
              ),
            ],
          ),
          // ✅ Zonas seguras → VERDE
          MarkerLayer(
            markers: zonasSeguras
                .map(
                  (zona) => Marker(
                point: zona.posicion,
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.location_on, // mismo icono
                  color: Colors.green, // 🟢 verde
                  size: 30,
                ),
              ),
            )
                .toList(),
          ),
          // 🔵 Recorrido
          PolylineLayer(
            polylines: [
              Polyline(
                points: recorrido,
                color: AppTheme.secondary,
                strokeWidth: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
