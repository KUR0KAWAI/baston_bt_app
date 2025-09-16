import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:latlong2/latlong.dart';

class HistorialListMap extends StatelessWidget {
  final List<LatLng> recorrido;

  const HistorialListMap({super.key, required this.recorrido});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: AppTheme.secondary),
              const SizedBox(width: 6),
              Text(
                "Historial",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          recorrido.isEmpty
              ? Text(
            "No hay historial disponible",
            style: theme.textTheme.bodyMedium,
          )
              : ListView.builder(
            shrinkWrap: true, // ✅ Ajusta al contenido
            physics: const NeverScrollableScrollPhysics(), // ✅ evita scroll interno
            itemCount: recorrido.length,
            itemBuilder: (context, index) {
              final p = recorrido[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: AppTheme.secondary,
                  ),
                  title: Text(
                    "Punto ${index + 1}",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Lat: ${p.latitude.toStringAsFixed(4)}, "
                        "Lon: ${p.longitude.toStringAsFixed(4)}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
