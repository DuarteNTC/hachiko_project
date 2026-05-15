class QrPayload {
  final String clientId;
  final String nonce;
  final String signature;

  QrPayload({required this.clientId, required this.nonce, required this.signature});
}