import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ArtistScanScreen extends StatefulWidget {
  const ArtistScanScreen({super.key});

  @override
  State<ArtistScanScreen> createState() => _ArtistScanScreenState();
}

class _ArtistScanScreenState extends State<ArtistScanScreen> {
  bool scanned = false;

  void handleDetect(BarcodeCapture capture) {
    if (scanned) return;

    final code = capture.barcodes.first.rawValue;

    if (code == null) return;

    scanned = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cliente detectado'),
        content: Text(code),
        actions: [
          TextButton(
            onPressed: () {
              scanned = false;
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
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
      ),
      body: MobileScanner(
        onDetect: handleDetect,
      ),
    );
  }
}