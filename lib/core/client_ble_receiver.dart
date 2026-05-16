import 'dart:convert';

import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

import '../data/models/client_model.dart';
import '../data/repositories/local_repository.dart';

class ClientBleReceiver {
  final repo = LocalRepository();

  static const String serviceUuid =
      '12345678-1234-1234-1234-123456789abc';

  Future<void> start(ClientModel client) async {
    final peripheral = FlutterBlePeripheral();

    await peripheral.start(
      advertiseData: AdvertiseData(
        serviceUuid: serviceUuid,
        localName: client.id,
        includeDeviceName: true,
      ),
    );
  }

  Future<void> applyPayload(String raw) async {
    final decoded = jsonDecode(raw);

    final current = repo.getCurrentClient();

    if (current == null) return;

    if (decoded['clientId'] != current.id) return;

    final updated = current.copyWith(
      stamps: decoded['stamps'],
      updatedAt: DateTime.now(),
    );

    await repo.saveCurrentClient(updated);
  }
}