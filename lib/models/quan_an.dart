class QuanAn {
  final int id;
  final String avt;
  final String ten;
  final String mo_ta;
  final String dia_chi;
  final int dia_danh_id;

  QuanAn(
      {required this.id,
      required this.avt,
      required this.ten,
      required this.mo_ta,
      required this.dia_chi,
      required this.dia_danh_id});

  factory QuanAn.fromJson(Map<String, dynamic> json) {
    return QuanAn(
        id: json["id"],
        avt: json["avt"],
        ten: json["ten"],
        mo_ta: json["mo_ta"],
        dia_chi: json["dia_chi"],
        dia_danh_id: json["dia_danh_id"]);
  }
}
