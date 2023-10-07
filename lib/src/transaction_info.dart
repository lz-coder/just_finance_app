class TransactionInfo {
  final int id;
  final String title;
  final int incomming;
  final double value;

  const TransactionInfo({
    required this.id,
    required this.title,
    required this.incomming,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'incomming': incomming,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, incomming: $incomming, value: $value}';
  }
}
