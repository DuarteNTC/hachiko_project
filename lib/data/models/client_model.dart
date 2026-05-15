class ClientModel {
  final String id;
  final String name;
  final int stamps;
  final List<String> historyIds;
  final DateTime updatedAt;
  final String signature;

  ClientModel({required this.id, required this.name, required this.stamps, required this.historyIds, required this.updatedAt, required this.signature});
}