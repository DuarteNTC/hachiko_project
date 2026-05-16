import 'package:hive_flutter/hive_flutter.dart';
import '../models/client_model.dart';

class LocalRepository {
  final Box box = Hive.box('clients');

  Future<void> saveClient(ClientModel client) async {
    await box.put(client.id, client.toMap());
  }

  ClientModel? getClientById(String id) {
    final data = box.get(id);

    if (data == null) return null;

    return ClientModel.fromMap(Map<String, dynamic>.from(data));
  }

  ClientModel? getCurrentClient() {
    final data = box.get('current_client');

    if (data == null) return null;

    return ClientModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> saveCurrentClient(ClientModel client) async {
    await box.put('current_client', client.toMap());
    await box.put(client.id, client.toMap());
  }

  Future<ClientModel> addStamp(String clientId) async {
    final existing = getClientById(clientId);

    if (existing != null) {
      final updated = existing.copyWith(
        stamps: existing.stamps + 1,
        updatedAt: DateTime.now(),
      );

      await saveClient(updated);

      return updated;
    }

    final created = ClientModel(
      id: clientId,
      name: "Cliente",
      stamps: 1,
      historyIds: [],
      updatedAt: DateTime.now(),
      signature: "pending",
    );

    await saveClient(created);

    return created;
  }
}