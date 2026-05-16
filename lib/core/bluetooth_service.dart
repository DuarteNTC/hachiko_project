import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  BluetoothCharacteristic? writeChar;

  Future<bool> scanAndConnect(String targetName) async {
    bool connected = false;

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));

    await for (final results in FlutterBluePlus.scanResults) {
      for (final result in results) {
        if (result.device.platformName == targetName) {
          await FlutterBluePlus.stopScan();

          await result.device.connect();

          final services = await result.device.discoverServices();

          for (final service in services) {
            for (final c in service.characteristics) {
              if (c.properties.write) {
                writeChar = c;
                connected = true;
                return connected;
              }
            }
          }
        }
      }
    }

    return connected;
  }

  Future<void> sendStamp({
    required String clientId,
    required int stamps,
  }) async {
    if (writeChar == null) return;

    final payload = jsonEncode({
      'clientId': clientId,
      'stamps': stamps,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await writeChar!.write(
      utf8.encode(payload),
      withoutResponse: false,
    );
  }
}