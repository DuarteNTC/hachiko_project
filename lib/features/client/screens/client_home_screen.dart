import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/client_ble_receiver.dart';
import '../../../data/models/client_model.dart';
import '../../../data/repositories/local_repository.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final repo = LocalRepository();
  final receiver = ClientBleReceiver();

  ClientModel? client;

  @override
  void initState() {
    super.initState();
    loadClient();
  }

  Future<void> loadClient() async {
    final saved = repo.getCurrentClient();

    if (saved != null) {
      await receiver.start(saved);

      setState(() {
        client = saved;
      });

      return;
    }

    final newClient = ClientModel(
      id: const Uuid().v4(),
      name: "Cliente Demo",
      stamps: 0,
      historyIds: [],
      updatedAt: DateTime.now(),
      signature: "pending",
    );

    await repo.saveCurrentClient(newClient);

    await receiver.start(newClient);

    setState(() {
      client = newClient;
    });
  }

  Future<void> refreshClient() async {
    final updated = repo.getCurrentClient();

    if (updated == null) return;

    setState(() {
      client = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Cartão'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshClient,
        child: ListView(
          children: [
            const SizedBox(height: 80),

            Center(
              child: Column(
                children: [
                  Text(
                    client!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Carimbos: ${client!.stamps}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 30),

                  QrImageView(
                    data: client!.id,
                    size: 250,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Mostre este QR ao tatuador',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}