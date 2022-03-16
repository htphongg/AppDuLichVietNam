class Vung {
  final int id;
  final String ten_vung;

  Vung({required this.id, required this.ten_vung});

  factory Vung.fromJson(Map<String, dynamic> json) {
    return Vung(id: json["id"], ten_vung: json["ten"]);
  }
}
