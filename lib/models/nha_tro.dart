class NhaTro {
  final int id;
  final String avt;
  final String ten;
  final String mo_ta;
  final String gia;
  final String dia_chi;
  final int dia_danh_id;

  NhaTro(
      {required this.id,
      required this.avt,
      required this.ten,
      required this.mo_ta,
      required this.gia,
      required this.dia_chi,
      required this.dia_danh_id});

  factory NhaTro.fromJson(Map<String, dynamic> json) {
    return NhaTro(
        id: json["id"],
        avt: json["avt"],
        ten: json["ten"],
        mo_ta: json["mo_ta"],
        gia: json["gia"],
        dia_chi: json["dia_chi"],
        dia_danh_id: json["dia_danh_id"]);
  }
}
