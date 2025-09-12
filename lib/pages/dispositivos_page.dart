import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({super.key});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice? _dispositivoConectado;
  bool _inicializado = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verificarEstadoBluetooth();
    _iniciarVerificacionPeriodica();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _verificarEstadoBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state;
      });
      if (state == BluetoothState.STATE_ON) {
        _verificarConexion();
      } else {
        setState(() {
          _dispositivoConectado = null;
        });
      }
    });

    if (_bluetoothState == BluetoothState.STATE_ON) {
      _verificarConexion();
    }

    setState(() {
      _inicializado = true;
    });
  }

  void _iniciarVerificacionPeriodica() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_bluetoothState == BluetoothState.STATE_ON) {
        _verificarConexion();
      }
    });
  }

  void _verificarConexion() async {
    final bonded = await FlutterBluetoothSerial.instance.getBondedDevices();
    for (var device in bonded) {
      if (await device.isConnected) {
        if (_dispositivoConectado?.address != device.address) {
          setState(() {
            _dispositivoConectado = device;
          });
        }
        return;
      }
    }

    if (_dispositivoConectado != null) {
      setState(() {
        _dispositivoConectado = null;
      });
    }
  }

  void _abrirAjustesBluetooth() {
    FlutterBluetoothSerial.instance.openSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispositivos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _verificarEstadoBluetooth,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _bluetoothState == BluetoothState.STATE_OFF
            ? _buildBluetoothApagado()
            : _dispositivoConectado != null
            ? _buildDispositivoConectado()
            : _buildNoConectado(),
      ),
    );
  }

  Widget _buildBluetoothApagado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth_disabled, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Bluetooth está apagado.",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _abrirAjustesBluetooth,
            child: const Text("Activar Bluetooth"),
          ),
        ],
      ),
    );
  }

  Widget _buildDispositivoConectado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth_connected, size: 72, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            "Dispositivo conectado:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            _dispositivoConectado!.name ?? "Sin nombre",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            _dispositivoConectado!.address,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNoConectado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth_searching, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No hay dispositivo conectado.",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _abrirAjustesBluetooth,
            child: const Text("Abrir ajustes Bluetooth"),
          ),
        ],
      ),
    );
  }
}
