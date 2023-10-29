class TransactionInfo {
  final int id;
  String title;
  final int income;
  double value;
  int category;
  String categoryName;
  final int year;
  final int month;
  final String date;

  TransactionInfo({
    required this.id,
    required this.title,
    required this.income,
    required this.value,
    required this.category,
    required this.categoryName,
    required this.year,
    required this.month,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'income': income,
      'value': value,
      'category': category,
      'categoryName': categoryName,
      'year': year,
      'month': month,
      'date': date,
    };
  }

  set setTitle(String value) => title = value;
  set setValue(double newValue) => value = newValue;
  set setCategorie(int value) => category = value;

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, incomming: $income, value: $value}, categorie_is: $category';
  }
}
