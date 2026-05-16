import 'package:hive_flutter/hive_flutter.dart';
import '../models/client_model.dart';

class LocalRepository {
  final Box box = Hive.box('clients');

  Future<void> saveClient(ClientModel client) async {
    await box.put('current_client', client.toMap());
  }

  ClientModel? getClient() {
    final data = box.get('current_client');

    if (data == null) return null;

    return ClientModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<ClientModel?> addStamp(String clientId) async {
    final client = getClient();

    if (client == null) return null;
    if (client.id != clientId) return null;

    final updated = ClientModel(
      id: client.id,
      name: client.name,
      stamps: client.stamps + 1,
      historyIds: client.historyIds,
      updatedAt: DateTime.now(),
      signature: client.signature,
    );

    await saveClient(updated);

    return updated;
  }
}