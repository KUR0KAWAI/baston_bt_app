import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';

class BtHelper {
  static final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  /// Verifica si el Bluetooth está activado
  static Future<bool> isBluetoothEnabled() async {
    return await _bluetooth.isEnabled ?? false;
  }

  /// Abre los ajustes de Bluetooth del sistema
  static Future<void> openBluetoothSettings() async {
    await _bluetooth.openSettings();
  }

  /// Retorna el primer dispositivo conectado actualmente (si lo hay)
  static Future<BluetoothDevice?> getConnectedDevice() async {
    try {
      final devices = await _bluetooth.getBondedDevices();
      for (BluetoothDevice device in devices) {
        // Verificamos si el dispositivo está conectado (solo algunos lo reportan bien)
        if (device.isConnected == true) {
          return device;
        }
      }
    } catch (e) {
      debugPrint('Error al obtener dispositivos conectados: $e');
    }
    return null;
  }
}
