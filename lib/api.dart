import 'package:http/http.dart' as http;

class API {
  String url;
  API({required this.url});

  Future<String> getDataString() async {
    final respone = await http.get(Uri.parse(url));
    if (respone.statusCode == 200 && respone.body.isNotEmpty) {
      return respone.body;
    } else {
      throw Exception('Failed');
    }
  }
}
