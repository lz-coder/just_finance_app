class TransactionInfo {
  final int id;
  String title;
  final int incomming;
  double value;

  TransactionInfo({
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

  set setTitle(value) => title = value;
  set setValue(double newValue) => value = newValue;

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, incomming: $incomming, value: $value}';
  }
}
