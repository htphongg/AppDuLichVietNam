class User {
  final int id;
  final String avt;
  final String username;
  final String password;
  final String fullname;
  final String email;
  final String phonenumber;
  final String display_state;

  User({
    required this.id,
    required this.avt,
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.display_state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        avt: json["avt"],
        username: json["ten_dang_nhap"],
        password: json["mat_khau"],
        fullname: json['ho_ten'],
        email: json["email"],
        phonenumber: json["so_dien_thoai"],
        display_state: json["trang_thai_hien_thi"]);
  }
}
