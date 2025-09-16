import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 🎤 voz TTS
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/zona_segura.dart';
import 'loading_walking_widget.dart'; // 👈 tu loader personalizado

class ZonasSegurasList extends StatefulWidget {
  final List<ZonaSegura> zonasSeguras;
  final Function(ZonaSegura) onEliminarZona;

  const ZonasSegurasList({
    super.key,
    required this.zonasSeguras,
    required this.onEliminarZona,
  });

  @override
  State<ZonasSegurasList> createState() => _ZonasSegurasListState();
}

class _ZonasSegurasListState extends State<ZonasSegurasList> {
  final FlutterTts flutterTts = FlutterTts();

  // 📌 función para abrir Google Maps con voz + loader + validación
  Future<void> _abrirGoogleMaps(ZonaSegura zona) async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${zona.posicion.latitude},${zona.posicion.longitude}&travelmode=walking");

    try {
      // 🎤 Voz antes de redirigir
      await flutterTts.speak(
          "Redirigiendo a Google Maps con indicaciones hacia ${zona.nombre}");

      // Mostrar loader
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const LoadingWalkingWidget(
            message: "Abriendo Google Maps...",
          ),
        );
      }

      // Espera mínima para que el loader se vea
      await Future.delayed(const Duration(seconds: 4));

      // Intentar abrir Google Maps directamente (como en tu code funcional)
      final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!ok) {
        throw Exception("No se pudo abrir Google Maps");
      }
    } catch (e) {
      // ⚠️ Si algo falla → voz + snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Error: $e")),
        );
      }
      await flutterTts.speak("No se pudo abrir Google Maps");
    } finally {
      // ✅ Cerrar loader siempre
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  // 📌 función para eliminar zona segura (igual que ya tenías)
  Future<void> _eliminarZona(ZonaSegura zona) async {
    int segundos = 3;

    await flutterTts.speak(
        "¿Estás seguro que quieres eliminar ${zona.nombre} de las zonas seguras?");

    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            Future(() async {
              for (var i = segundos; i > 0; i--) {
                await Future.delayed(const Duration(seconds: 1));
                setStateDialog(() {
                  segundos = i - 1;
                });
              }
            });

            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content: Text(
                  "¿Seguro que quieres eliminar la zona '${zona.nombre}' de las zonas seguras?"),
              actions: [
                TextButton(
                  onPressed: () {
                    flutterTts.stop();
                    Navigator.pop(ctx, false);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    segundos > 0 ? Colors.grey : Colors.red,
                  ),
                  onPressed: segundos > 0
                      ? null
                      : () {
                    flutterTts.stop();
                    Navigator.pop(ctx, true);
                  },
                  child: Text(
                    segundos > 0 ? "Eliminar (${segundos}s)" : "Eliminar",
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmar == true) {
      widget.onEliminarZona(zona);
      await flutterTts.speak("Zona segura ${zona.nombre} eliminada");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: AppTheme.success),
            const SizedBox(width: 6),
            Text(
              "Zonas Seguras",
              style: theme.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        widget.zonasSeguras.isEmpty
            ? Text("No hay zonas registradas",
            style: theme.textTheme.bodyMedium)
            : SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: widget.zonasSeguras.length,
            itemBuilder: (context, index) {
              final z = widget.zonasSeguras[index];
              return Card(
                elevation: 2,
                margin:
                const EdgeInsets.symmetric(vertical: 6.0),
                child: ListTile(
                  leading: const Icon(Icons.location_on,
                      color: AppTheme.success),
                  title: Text(
                    z.nombre,
                    style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Lat: ${z.posicion.latitude.toStringAsFixed(4)}\n"
                        "Lon: ${z.posicion.longitude.toStringAsFixed(4)}",
                    style: theme.textTheme.bodyMedium,
                  ),
                  onTap: () => _abrirGoogleMaps(z),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () => _eliminarZona(z),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
