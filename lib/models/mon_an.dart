class MonAn {
  final int id;
  final String avt;
  final String ten;
  final String mo_ta;
  final String gia;
  final int quan_an_id;
  final int dia_danh_id;

  MonAn(
      {required this.id,
      required this.avt,
      required this.ten,
      required this.mo_ta,
      required this.gia,
      required this.quan_an_id,
      required this.dia_danh_id});

  factory MonAn.fromJson(Map<String, dynamic> json) {
    return MonAn(
        id: json["id"],
        avt: json["avt"],
        ten: json["ten"],
        mo_ta: json["mo_ta"],
        gia: json["gia"],
        quan_an_id: json["quan_an_id"],
        dia_danh_id: json["dia_danh_id"]);
  }
}
