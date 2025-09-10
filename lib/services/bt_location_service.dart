import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

class BtLocationService {
  static Future<Map<String, double>?> obtenerUbicacionDesdeBaston(BluetoothDevice device) async {
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      print('[BT] Conectado al bastón');

      final completer = Completer<Map<String, double>?>();
      final buffer = StringBuffer();

      connection.input?.listen((Uint8List data) {
        final received = utf8.decode(data);
        buffer.write(received);

        if (received.contains('\n')) {
          final line = buffer.toString().trim();
          connection.finish(); // cerrar conexión
          print('[BT] Línea recibida: $line');

          final parts = line.split(',');
          final lat = double.tryParse(parts[0].split(':')[1]);
          final lng = double.tryParse(parts[1].split(':')[1]);

          if (lat != null && lng != null) {
            completer.complete({'lat': lat, 'lng': lng});
          } else {
            completer.complete(null);
          }
        }
      });

      return await completer.future;
    } catch (e) {
      print('[BT] Error al obtener ubicación: $e');
      return null;
    }
  }
}
