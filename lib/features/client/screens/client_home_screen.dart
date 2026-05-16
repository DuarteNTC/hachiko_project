import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/client_model.dart';
import '../../../data/repositories/local_repository.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final repo = LocalRepository();
  ClientModel? client;

  @override
  void initState() {
    super.initState();
    loadClient();
  }

  Future<void> loadClient() async {
    final saved = repo.getCurrentClient();

    if (saved != null) {
      setState(() => client = saved);
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

    setState(() => client = newClient);
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Meu Cartão")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(client!.name),
            const SizedBox(height: 20),
            Text("Carimbos: ${client!.stamps}"),
            const SizedBox(height: 30),
            QrImageView(
              data: client!.id,
              size: 250,
            ),
          ],
        ),
      ),
    );
  }
}