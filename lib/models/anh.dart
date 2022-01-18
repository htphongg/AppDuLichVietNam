class Anh {
  String path;

  Anh({required this.path});

  factory Anh.fromJson(Map<String, dynamic> json) {
    return Anh(path: json["path"] as String);
  }
}
