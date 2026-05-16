import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/repositories/local_repository.dart';

class ArtistScanScreen extends StatefulWidget {
  const ArtistScanScreen({super.key});

  @override
  State<ArtistScanScreen> createState() => _ArtistScanScreenState();
}

class _ArtistScanScreenState extends State<ArtistScanScreen> {
  bool scanned = false;
  final repo = LocalRepository();

  Future<void> handleDetect(BarcodeCapture capture) async {
    if (scanned) return;

    final code = capture.barcodes.first.rawValue;

    if (code == null) return;

    scanned = true;

    final updated = await repo.addStamp(code);

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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner Tattoo')),
      body: MobileScanner(
        onDetect: handleDetect,
      ),
    );
  }
}