class HoatDong {
  final int id;
  final String ten;

  HoatDong({required this.id, required this.ten});

  factory HoatDong.fromJson(Map<String, dynamic> json) {
    return HoatDong(id: json["id"], ten: json["ten"]);
  }
}
