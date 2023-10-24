class Category {
  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  final int id;
  String name;
  String type;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, type: $type}';
  }
}

class CategoryTypes {
  static const String income = 'income';
  static const String expense = 'expense';
}
