class Provinces {
  final String id;
  final String name;

  Provinces({
    required this.id,
    required this.name,
  });

  factory Provinces.fromDocument(Map<String, dynamic> json) {
    return Provinces(
      id: json["id"],
      name: json["name"],
    );
  }
}