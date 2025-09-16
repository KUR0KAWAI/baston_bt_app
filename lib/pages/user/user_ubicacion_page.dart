import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_tts/flutter_tts.dart';  // 🎤 librería TTS
import '../../models/zona_segura.dart';
import '../../widgets/mapa_widget.dart';
import '../../widgets/zonas_seguras_list.dart';
import '../../widgets/historial_list_map.dart';
import '../../widgets/add_zona_segura_dialog.dart';

class UserUbicacionPage extends StatefulWidget {
  const UserUbicacionPage({super.key});

  @override
  State<UserUbicacionPage> createState() => _UserUbicacionPageState();
}

class _UserUbicacionPageState extends State<UserUbicacionPage> {
  LatLng? ubicacionActual;
  final List<LatLng> recorrido = [];
  final List<ZonaSegura> zonasSeguras = [];
  bool bastonConectado = false;

  final FlutterTts flutterTts = FlutterTts(); // 🎤 instancia de TTS

  @override
  void initState() {
    super.initState();
    _initTts(); // 👈 inicializamos TTS al arrancar
    // 📌 Simulación sin bastón
    setState(() {
      bastonConectado = true;
      ubicacionActual = LatLng(-1.8019, -79.5344); // Ejemplo: Babahoyo
      recorrido.add(ubicacionActual!);
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("es-ES"); // español
    await flutterTts.setPitch(1.0);        // tono normal
    await flutterTts.setSpeechRate(0.5);   // velocidad moderada
  }

  Future<void> agregarZonaSegura(LatLng punto) async {
    final nombre = await showDialog<String>(
      context: context,
      builder: (_) => const AddZonaSeguraDialog(),
    );

    if (nombre != null && nombre.isNotEmpty) {
      setState(() {
        zonasSeguras.add(ZonaSegura(nombre: nombre, posicion: punto));
      });

      // 📢 SnackBar en pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Zona segura '$nombre' registrada")),
      );

      // 🎤 Voz TTS
      await flutterTts.speak("Zona segura $nombre registrada");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubicación - Usuario"),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🗺️ MAPA en tarjeta
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 250,
              child: MapaWidget(
                ubicacionActual: ubicacionActual,
                recorrido: recorrido,
                zonasSeguras: zonasSeguras,
                bastonConectado: bastonConectado,
                onTapMapa: agregarZonaSegura,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 📍 Texto debajo del mapa
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ubicacionActual != null ? Icons.check_circle : Icons.error,
                color: ubicacionActual != null ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                ubicacionActual != null
                    ? "Última posición obtenida del bastón"
                    : "No se ha obtenido la ubicación del bastón",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ubicacionActual != null
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 📍 ZONAS SEGURAS
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ZonasSegurasList(
                zonasSeguras: zonasSeguras,
                // 👇 ahora le paso el callback al hijo
                onEliminarZona: (zona) {
                  setState(() {
                    zonasSeguras.remove(zona); // 🔥 actualiza lista + mapa
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 📜 HISTORIAL
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: HistorialListMap(recorrido: recorrido),
            ),
          ),
        ],
      ),
    );
  }
}
