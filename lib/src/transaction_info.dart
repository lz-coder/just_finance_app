class TransactionInfo {
  final int id;
  String title;
  final int income;
  double value;
  int categorie;
  String categorieName;

  TransactionInfo({
    required this.id,
    required this.title,
    required this.income,
    required this.value,
    required this.categorie,
    required this.categorieName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'incomming': income,
      'value': value,
      'categorie': categorie,
      'categorieName': categorieName,
    };
  }

  set setTitle(String value) => title = value;
  set setValue(double newValue) => value = newValue;
  set setCategorie(int value) => categorie = value;

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, incomming: $income, value: $value}, categorie_is: $categorie';
  }
}
