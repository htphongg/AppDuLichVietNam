class DiaDanh {
  final int id;
  final String avt;
  final String ten_dia_danh;
  final String mo_ta;
  final int luot_checkin;
  final int luot_thich;
  final int vung_id;
  final int mien_id;
  final double kinh_do;
  final double vi_do;

  DiaDanh(
      {required this.id,
      required this.avt,
      required this.ten_dia_danh,
      required this.mo_ta,
      required this.luot_checkin,
      required this.luot_thich,
      required this.vung_id,
      required this.mien_id,
      required this.kinh_do,
      required this.vi_do});

  factory DiaDanh.fromJson(Map<String, dynamic> json) {
    return DiaDanh(
        id: json["id"],
        avt: json["avt"],
        ten_dia_danh: json["ten"],
        mo_ta: json["mo_ta"],
        luot_checkin: json["luot_checkin"],
        luot_thich: json["luot_thich"],
        vung_id: json["vung_id"],
        mien_id: json["mien_id"],
        kinh_do: json["kinh_do"],
        vi_do: json["vi_do"]);
  }
}
