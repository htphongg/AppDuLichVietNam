import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';

class WirteReviewPost extends StatefulWidget {
  int diaDanhId;

  WirteReviewPost({Key? key, required this.diaDanhId}) : super(key: key);

  @override
  _WirteReviewPostState createState() => _WirteReviewPostState();
}

class _WirteReviewPostState extends State<WirteReviewPost> {
  late TextEditingController _tieude;
  late TextEditingController _noidung;

  Iterable resultDangBai = [];

  Future<void> vietBai(int dia_danh_id, String tieude, String noidung) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "http://10.0.2.2:8000/viet-bai/$_user_id/$dia_danh_id/$tieude/$noidung")
        .getDataString()
        .then((value) => resultDangBai = json.decode(value));
    if (resultDangBai.elementAt(0)["state"] == "true")
      showAlertDialog(context, resultDangBai.elementAt(0)["state"],
          resultDangBai.elementAt(0)["message"]);
    else
      showAlertDialog(context, resultDangBai.elementAt(0)["state"],
          resultDangBai.elementAt(0)["message"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tieude = TextEditingController();
    _noidung = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tieude.dispose();
    _noidung.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá địa danh'),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                      Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                      Icon(
                        Icons.star,
                        color: Colors.yellow.shade700,
                        size: 40,
                      )
                    ],
                  ),
                  GestureDetector(
                    // onTap: () => pickImage(),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      width: 200,
                      height: 80,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_enhance, size: 40),
                          Text(
                            'Thêm hình ảnh',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   child: images == null
                  //       ? const Text('Không có hình ảnh nào dc chọn')
                  //       : Image.file(images!,
                  //           width: 160, height: 160, fit: BoxFit.cover),
                  // ),
                  const SizedBox(height: 25),
                  Container(
                    child: TextFormField(
                      controller: _tieude,
                      minLines: 1,
                      maxLength: 50,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề:',
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _noidung,
                      minLines: 1,
                      maxLength: 500,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText:
                            'Chia sẻ điều bạn thích về địa danh này nhé.',
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_tieude.text.isNotEmpty &&
                              _noidung.text.isNotEmpty) {
                            vietBai(
                                widget.diaDanhId, _tieude.text, _noidung.text);
                          } else
                            showAlertDialog(context, "false",
                                "Hãy viết cảm nhận của bạn vào ô trống.");
                        },
                        child: const Text('Đăng')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, String state, String message) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      if (state == "true") {
        Navigator.pop(context);
        Navigator.pop(context);
      } else
        Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Thông báo"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
