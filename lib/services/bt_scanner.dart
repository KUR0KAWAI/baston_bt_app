import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum BtType { classic }

class FoundDevice {
  final String displayName;
  final String address;
  final int? rssi;
  final BtType type;

  FoundDevice({
    required this.displayName,
    required this.address,
    this.rssi,
    required this.type,
  });
}

class BtScanStatus {
  final bool classicScanning;
  const BtScanStatus({required this.classicScanning});
}

enum ScanPhase { idle, classic }

class BtScanner {
  final ValueNotifier<List<FoundDevice>> disponibles = ValueNotifier([]);
  final ValueNotifier<List<FoundDevice>> sincronizados = ValueNotifier([]);
  final ValueNotifier<BtScanStatus> status =
  ValueNotifier(const BtScanStatus(classicScanning: false));
  final ValueNotifier<ScanPhase> phase = ValueNotifier(ScanPhase.idle);

  StreamSubscription<BluetoothDiscoveryResult>? _discoverySub;

  Future<void> startSequentialScan({bool classicFirst = true}) async {
    // Limpiar anteriores
    disponibles.value = [];
    status.value = const BtScanStatus(classicScanning: true);
    phase.value = ScanPhase.classic;

    // Iniciar descubrimiento clásico
    _discoverySub =
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
          final name = result.device.name ?? 'Desconocido';
          final address = result.device.address;

          final device = FoundDevice(
            displayName: name,
            address: address,
            rssi: result.rssi,
            type: BtType.classic,
          );

          // Solo agregar si no está ya
          final yaExiste = disponibles.value
              .any((d) => d.address.toUpperCase() == address.toUpperCase());
          if (!yaExiste) {
            disponibles.value = [...disponibles.value, device];
            debugPrint('[SCAN] Encontrado: $name ($address)');
          }
        });

    _discoverySub?.onDone(() {
      status.value = const BtScanStatus(classicScanning: false);
      phase.value = ScanPhase.idle;
      debugPrint('[SCAN] Escaneo clásico finalizado');
    });
  }

  void dispose() {
    _discoverySub?.cancel();
  }
}
