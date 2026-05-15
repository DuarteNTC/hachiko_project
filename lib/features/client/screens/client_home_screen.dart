import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const qrData = "cliente_001";

    return Scaffold(
      appBar: AppBar(title: const Text("Meu Cartão")),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 250,
        ),
      ),
    );
  }
}