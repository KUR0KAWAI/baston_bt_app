import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Posicion {
  final double lat;
  final double lon;
  Posicion(this.lat, this.lon);
}

class BtLocationService {
  static BluetoothConnection? _connection;
  static final _controller = StreamController<Posicion?>.broadcast();

  /// 📡 Devuelve un stream de ubicaciones
  static Stream<Posicion?> get ubicacionStream => _controller.stream;

  /// 🔗 Intentar conectar con el bastón
  static Future<bool> conectar(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('[BT] Conectado al bastón: ${device.name}');
      _escucharDatos();
      return true;
    } catch (e) {
      print('[BT] Error de conexión: $e');
      return false;
    }
  }

  /// ❌ Desconectar manualmente
  static void desconectar() {
    _connection?.finish();
    _connection = null;
    print('[BT] Conexión cerrada');
  }

  /// 👂 Escuchar datos que llegan del bastón
  static void _escucharDatos() {
    if (_connection == null) return;

    final buffer = StringBuffer();

    _connection!.input?.listen((Uint8List data) {
      final received = utf8.decode(data);
      buffer.write(received);

      if (received.contains('\n')) {
        final line = buffer.toString().trim();
        buffer.clear();
        print('[BT] Línea recibida: $line');

        try {
          final parts = line.split(',');
          final lat = double.tryParse(parts[0].split(':')[1]);
          final lon = double.tryParse(parts[1].split(':')[1]);

          if (lat != null && lon != null) {
            _controller.add(Posicion(lat, lon));
          } else {
            _controller.add(null);
          }
        } catch (e) {
          print('[BT] Error parseando coordenadas: $e');
          _controller.add(null);
        }
      }
    }, onDone: () {
      print('[BT] Conexión perdida');
      _controller.add(null); // Notificar que se perdió conexión
      _connection = null;
    }, onError: (err) {
      print('[BT] Error: $err');
      _controller.add(null);
      _connection = null;
    });
  }

  /// 🔎 Verifica si sigue conectado
  static bool get conectado => _connection != null && _connection!.isConnected;
}
