class User {
  final int id;
  final String avt;
  final String username;
  final String password;
  final String fullname;
  final String email;
  final bool state_email;
  final String phonenumber;
  final bool state_phonenumber;

  User(
      {required this.id,
      required this.avt,
      required this.username,
      required this.password,
      required this.fullname,
      required this.email,
      required this.state_email,
      required this.phonenumber,
      required this.state_phonenumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      avt: json["avt"],
      username: json["ten_dang_nhap"],
      password: json["mat_khau"],
      fullname: json['ho_ten'],
      email: json["email"],
      state_email: json["trang_thai_email"],
      phonenumber: json["so_dien_thoai"],
      state_phonenumber: json["trang_thai_sdt"],
    );
  }

  // Map<String, dynamic> toJson(User instance) {
  //   return <String, dynamic>{
  //     'id': instance.id,
  //     'avt': instance.avt,
  //     'ten_dang_nhap': instance.username,
  //     'mat_khau': instance.password,
  //     'ho_ten': instance.fullname,
  //     'email': instance.email,
  //     'so_dien_thoai': instance.phonenumber,
  //   };
  // }
}
