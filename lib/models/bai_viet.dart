class BaiViet {
  final int id;
  final String tieu_de;
  final String noi_dung;
  final DateTime ngay_dang;
  final int dia_danh_id;
  final int nguoi_dung_id;
  final String luot_thich;

  BaiViet({
    required this.id,
    required this.tieu_de,
    required this.noi_dung,
    required this.ngay_dang,
    required this.dia_danh_id,
    required this.nguoi_dung_id,
    required this.luot_thich,
  });

  factory BaiViet.fromJson(Map<String, dynamic> json) {
    return BaiViet(
        id: json["id"],
        tieu_de: json["tieu_de"],
        noi_dung: json["noi_dung"],
        ngay_dang: DateTime.parse(json["ngay_dang"]),
        dia_danh_id: json["dia_danh_id"],
        nguoi_dung_id: json["nguoi_dung_id"],
        luot_thich: json["so_luot_thich"]);
  }
}
