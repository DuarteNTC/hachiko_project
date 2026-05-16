class ClientModel {
  final String id;
  final String name;
  final int stamps;
  final List<String> historyIds;
  final DateTime updatedAt;
  final String signature;

  ClientModel({
    required this.id,
    required this.name,
    required this.stamps,
    required this.historyIds,
    required this.updatedAt,
    required this.signature,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stamps': stamps,
      'historyIds': historyIds,
      'updatedAt': updatedAt.toIso8601String(),
      'signature': signature,
    };
  }

  factory ClientModel.fromMap(Map map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      stamps: map['stamps'],
      historyIds: List<String>.from(map['historyIds']),
      updatedAt: DateTime.parse(map['updatedAt']),
      signature: map['signature'],
    );
  }

  ClientModel copyWith({
    String? name,
    int? stamps,
    List<String>? historyIds,
    DateTime? updatedAt,
    String? signature,
  }) {
    return ClientModel(
      id: id,
      name: name ?? this.name,
      stamps: stamps ?? this.stamps,
      historyIds: historyIds ?? this.historyIds,
      updatedAt: updatedAt ?? this.updatedAt,
      signature: signature ?? this.signature,
    );
  }
}