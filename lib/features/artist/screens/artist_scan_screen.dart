import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/bluetooth_service.dart';
import '../../../data/repositories/local_repository.dart';

class ArtistScanScreen extends StatefulWidget {
  const ArtistScanScreen({super.key});

  @override
  State<ArtistScanScreen> createState() => _ArtistScanScreenState();
}

class _ArtistScanScreenState extends State<ArtistScanScreen> {
  bool scanned = false;

  final repo = LocalRepository();
  final bluetooth = BluetoothService();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Future<void> handleDetect(BarcodeCapture capture) async {
    if (scanned) return;

    final code = capture.barcodes.first.rawValue;

    if (code == null) return;

    scanned = true;

    final updated = await repo.addStamp(code);

    if (updated != null) {
      await bluetooth.scanAndConnect(updated.id);

      await bluetooth.sendStamp(
        clientId: updated.id,
        stamps: updated.stamps,
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Carimbo realizado'),
        content: updated == null
            ? const Text('Cliente não encontrado')
            : Text('Novo total: ${updated.stamps}'),
        actions: [
          TextButton(
            onPressed: () {
              scanned = false;
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Tattoo'),
        centerTitle: true,
      ),
      body: MobileScanner(
        onDetect: handleDetect,
      ),
    );
  }
}