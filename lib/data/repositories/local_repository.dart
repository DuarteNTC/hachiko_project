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
}