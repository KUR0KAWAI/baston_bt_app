import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({super.key});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  bool _bluetoothActivado = false;
  bool _scanning = false;
  List<BluetoothDevice> _sincronizados = [];
  List<BluetoothDiscoveryResult> _disponibles = [];
  StreamSubscription<BluetoothDiscoveryResult>? _escaneoSub;

  @override
  void initState() {
    super.initState();
    _verificarBluetooth();
  }

  Future<void> _verificarBluetooth() async {
    final activado = await FlutterBluetoothSerial.instance.isEnabled ?? false;
    setState(() => _bluetoothActivado = activado);

    if (_bluetoothActivado) {
      _cargarDispositivosSincronizados();
      _iniciarEscaneo();
    }
  }

  Future<void> _abrirAjustesBluetooth() async {
    await FlutterBluetoothSerial.instance.openSettings();
    await Future.delayed(const Duration(seconds: 2));
    _verificarBluetooth();
  }

  Future<void> _cargarDispositivosSincronizados() async {
    final list = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() => _sincronizados = list);
  }

  Future<void> _iniciarEscaneo() async {
    setState(() {
      _disponibles.clear();
      _scanning = true;
    });

    _escaneoSub =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          final i =
          _disponibles.indexWhere((e) => e.device.address == r.device.address);
          if (i == -1) {
            setState(() => _disponibles.add(r));
          } else {
            setState(() => _disponibles[i] = r);
          }
        });

    // Detener escaneo luego de 20 segundos
    Future.delayed(const Duration(seconds: 20), () {
      _escaneoSub?.cancel();
      setState(() => _scanning = false);
    });
  }

  Future<void> _sincronizar(BluetoothDevice device) async {
    try {
      await FlutterBluetoothSerial.instance
          .bondDeviceAtAddress(device.address);

      final refreshed =
      await FlutterBluetoothSerial.instance.getBondedDevices();
      final encontrado =
      refreshed.any((d) => d.address == device.address);

      if (encontrado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sincronizado con ${device.name}')),
        );
        _cargarDispositivosSincronizados();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al sincronizar con ${device.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _olvidar(BluetoothDevice device) async {
    try {
      await FlutterBluetoothSerial.instance
          .removeDeviceBondWithAddress(device.address);

      final refreshed =
      await FlutterBluetoothSerial.instance.getBondedDevices();
      final sigue = refreshed.any((d) => d.address == device.address);

      if (!sigue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Olvidado: ${device.name}')),
        );
        _cargarDispositivosSincronizados();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al olvidar: ${device.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al olvidar: $e')),
      );
    }
  }

  Widget _buildListaSincronizados() {
    if (_sincronizados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text('No hay dispositivos sincronizados.')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _sincronizados.map((d) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.bluetooth_connected),
            title: Text(d.name ?? 'Desconocido'),
            subtitle: Text(d.address),
            trailing: Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _olvidar(d),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Olvidar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Conexión RFCOMM futura
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Conectar'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListaDisponibles() {
    if (_disponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text('No se detectaron dispositivos.')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _disponibles.map((r) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.bluetooth_searching),
            title: Text(r.device.name ?? 'Desconocido'),
            subtitle: Text(r.device.address),
            trailing: ElevatedButton(
              onPressed: () => _sincronizar(r.device),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Sincronizar'),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _escaneoSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _verificarBluetooth();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _verificarBluetooth();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_bluetoothActivado) ...[
              const Text(
                'Activa Bluetooth para detectar dispositivos cercanos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _abrirAjustesBluetooth,
                  icon: const Icon(Icons.bluetooth),
                  label: const Text('Abrir ajustes de Bluetooth'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ] else ...[
              if (_scanning) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 8),
                const Center(child: Text('Buscando dispositivos...')),
                const SizedBox(height: 12),
              ],
              const Text(
                'Dispositivos sincronizados',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildListaSincronizados(),
              const Divider(),
              const Text(
                'Dispositivos disponibles',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildListaDisponibles(),
            ],
          ],
        ),
      ),
    );
  }
}
