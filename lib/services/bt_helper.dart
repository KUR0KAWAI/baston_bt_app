// lib/services/bt_helper.dart
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class BtHelper {
  /// Pide permisos requeridos (Android). En iOS no se piden en runtime.
  static Future<bool> ensurePermissions() async {
    if (!Platform.isAndroid) return true;

    final reqs = <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ];


    final statuses = await reqs.request();
    return statuses.values.every((s) => s.isGranted);
  }

  /// ¿Adaptador encendido?
  static Future<bool> isOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  /// Abrir ajustes → Bluetooth
  static Future<void> openBluetoothSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
  }

  /// Abrir pantalla de permisos de la app
  static Future<void> openAppPermissionSettings() async {
    await AppSettings.openAppSettings(); // abre ajustes de la app
  }

  /// Abrir ajustes → Ubicación del sistema (Android <= 11)
  static Future<void> openLocationSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  /// Si BT está apagado → abre ajustes; si está encendido → true.
  static Future<bool> ensureOnOrOpenSettings() async {
    final okPerms = await ensurePermissions();
    if (!okPerms) return false;
    if (await isOn()) return true;
    await openBluetoothSettings();
    return false;
  }

  /// Escaneo BLE rápido
  static Future<void> startBleScan({Duration timeout = const Duration(seconds: 15)}) async {
    if (await isOn()) {
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidScanMode: AndroidScanMode.lowLatency,
      );
    }
  }

  static Future<void> stopBleScan() => FlutterBluePlus.stopScan();
}
