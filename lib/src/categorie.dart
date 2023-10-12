class Categorie {
  final int id;
  String name;
  final String type;

  Categorie({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Categorie{id: $id, name: $name, type: $type}';
  }
}

class CategorieTypes {
  static const String incomming = 'incomming';
  static const String dispense = 'dispense';
}
