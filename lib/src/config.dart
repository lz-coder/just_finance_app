import 'dart:ui';

class Config {
  const Config({
    required this.id,
    required this.name,
    required this.value,
  });

  final int id;
  final String name;
  final String value;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "value": value,
    };
  }

  Locale toLocale() {
    final valueSplitted = value.split('_');
    if (valueSplitted[1] == 'null') {
      return Locale(valueSplitted[0]);
    } else {
      return Locale(valueSplitted[0], valueSplitted[1]);
    }
  }

  @override
  String toString() {
    return "Config: {id: $id, name: $name, value: $value}";
  }
}
