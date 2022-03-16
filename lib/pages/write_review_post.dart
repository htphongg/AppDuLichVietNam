import 'dart:convert';
import 'dart:io';

import 'package:app_du_lich/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:image_picker/image_picker.dart';

class WirteReviewPost extends StatefulWidget {
  int diaDanhId;

  WirteReviewPost({Key? key, required this.diaDanhId}) : super(key: key);

  @override
  _WirteReviewPostState createState() => _WirteReviewPostState();
}

class _WirteReviewPostState extends State<WirteReviewPost> {
  late TextEditingController _tieude;
  late TextEditingController _noidung;
  Map<String, String> resultDangBai = Map<String, String>();
  double rating = 0;
  File? image;
  vietBai(
      int dia_danh_id, String tieude, String noidung, String? filename) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();

    var request = http.MultipartRequest(
        "POST", Uri.parse("https://travellappp.herokuapp.com/api/viet-bai"));
    if (filename != null) {
      request.files.add(await http.MultipartFile.fromPath('images', filename));
    }

    request.fields['tieu_de'] = tieude;
    request.fields['noi_dung'] = noidung;
    request.fields['dia_danh_id'] = dia_danh_id.toString();
    request.fields['user_id'] = _user_id;
    request.fields['rate'] = rating.toString();

    await request.send().then((response) {
      if (response.statusCode == 200) {
        showAlertDialog(context, "true", "Viết bài đánh giá thành công.");
      } else {
        showAlertDialog(context, "false", "Viết bài đánh giá thất bại");
      }
    });
  }

  Future pickImage() async {
    try {
      final image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imagePath = File(image.path);
      setState(() {
        this.image = imagePath;
      });
    } on PlatformException catch (e) {
      print("Không chọn đƯợc hình ảnh: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tieude = TextEditingController();
    _noidung = TextEditingController();
  }

  @override
  voidse() {
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
                  RatingBar.builder(
                      minRating: 1,
                      updateOnDrag: true,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          this.rating = rating;
                        });
                      }),
                  const SizedBox(height: 10),
                  rating == 5
                      ? const Text('Rất hài lòng',
                          style: TextStyle(fontSize: 18))
                      : rating == 4
                          ? const Text('Hơi hài lòng',
                              style: TextStyle(fontSize: 18))
                          : rating == 3
                              ? const Text('Bình thường',
                                  style: TextStyle(fontSize: 18))
                              : rating == 2
                                  ? const Text('Không hài lòng',
                                      style: TextStyle(fontSize: 18))
                                  : rating == 1
                                      ? const Text('Rất không hài lòng',
                                          style: TextStyle(fontSize: 18))
                                      : const Text(''),
                  GestureDetector(
                    onTap: () => pickImage(),
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
                  Container(
                    child: image == null
                        ? const Text('Không có hình ảnh nào dc chọn')
                        : Image.file(image!,
                            width: 160, height: 160, fit: BoxFit.cover),
                  ),
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
                      maxLength: 300,
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
                            vietBai(widget.diaDanhId, _tieude.text,
                                _noidung.text, image?.path);
                          } else {
                            showAlertDialog(context, "false",
                                "Hãy viết cảm nhận của bạn vào ô trống.");
                          }
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
