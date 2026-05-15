class StampTransaction {
  final String txId;
  final String clientId;
  final int added;
  final DateTime date;
  final String artistId;

  StampTransaction({required this.txId, required this.clientId, required this.added, required this.date, required this.artistId});
}