class Year {
  final int year;

  const Year({
    required this.year,
  });

  Map<String, int> toMap() {
    return {'year': year};
  }
}
