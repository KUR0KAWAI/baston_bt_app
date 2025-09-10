import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  LatLng? ubicacionActual;
  String direccion = 'Babahoyo, Ecuador';

  // 🔐 Pega aquí tu API KEY de OpenRouteService:
  final String apiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImE5NzBmOWEyMGFlODRhZWQ5NWEyYTRlMDhmMjZiODQzIiwiaCI6Im11cm11cjY0In0='; // ← Reemplaza este valor

  final TextEditingController direccionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    direccionController.text = direccion;
    obtenerUbicacionDesdeDireccion(direccion);
  }

  Future<void> obtenerUbicacionDesdeDireccion(String direccion) async {
    final url = Uri.parse(
      'https://api.openrouteservice.org/geocode/search?api_key=$apiKey&text=$direccion',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'];
        final lon = coords[0];
        final lat = coords[1];

        print('Coords de "$direccion": lat=$lat, lon=$lon');
        setState(() {
          ubicacionActual = LatLng(lat, lon);
        });
      } else {
        print('Error al consultar ORS: ${response.body}');
      }
    } catch (e) {
      print('Error ORS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar dirección',
            onPressed: () {
              obtenerUbicacionDesdeDireccion(direccionController.text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mapa / Ubicación Actual',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            TextField(
              controller: direccionController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    obtenerUbicacionDesdeDireccion(direccionController.text);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 200,
              child: ubicacionActual == null
                  ? const Center(child: CircularProgressIndicator())
                  : FlutterMap(
                options: MapOptions(
                  initialCenter: ubicacionActual!,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.baston_bt_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ubicacionActual!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Zonas Seguras',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Hogar')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Centro de salud')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Agregar zona segura'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Historial',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Hoy, 10:20 • Parque'),
            ),
          ],
        ),
      ),
    );
  }
}
