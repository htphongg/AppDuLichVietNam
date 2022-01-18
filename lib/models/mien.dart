class Mien {
  final int id;
  final String ten_mien;

  Mien({required this.id, required this.ten_mien});

  factory Mien.fromJson(Map<String, dynamic> json) {
    return Mien(id: json["id"], ten_mien: json["ten"]);
  }
}
