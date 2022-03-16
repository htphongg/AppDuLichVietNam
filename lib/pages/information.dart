import 'dart:convert';
import 'dart:math';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:app_du_lich/pages/change_password.dart';
import 'package:app_du_lich/pages/details_account.dart';
import 'package:app_du_lich/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class Informaition extends StatefulWidget {
  Informaition({Key? key}) : super(key: key);

  @override
  _InformaitionState createState() => _InformaitionState();
}

class _InformaitionState extends State<Informaition> {
  late TextEditingController ho_ten;
  late TextEditingController phone_number;
  late TextEditingController email;
  late User tTinUser;

  Iterable result = [];

  Future<void> layThongTinNgDung() async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/thong-tin-ng-dung/$_user_id")
        .getDataString()
        .then((value) => tTinUser = User.fromJson(json.decode(value)));

    ho_ten.text = tTinUser.fullname;
    email.text = tTinUser.email;
    phone_number.text = tTinUser.phonenumber;
    setState(() {});
  }

  Future<void> capNhatThongTinCaNhan(
      int id, String ho_ten, String email, String sdt) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/cap-nhat-thong-tin/$id/$ho_ten/$email/$sdt")
        .getDataString()
        .then((value) => result = json.decode(value));

    if (result.elementAt(0)["state"] == "true") {
      showAlertDialog(context, result.elementAt(0)["message"]);
    } else {
      showAlertDialog(context, result.elementAt(0)["message"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ho_ten = TextEditingController();
    phone_number = TextEditingController();
    email = TextEditingController();

    tTinUser = User(
        id: 0,
        avt: "",
        username: "",
        password: "",
        fullname: "",
        email: "",
        state_email: -1,
        phonenumber: "",
        state_phonenumber: -1);

    layThongTinNgDung();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin cá nhân'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildCategory('Thông tin cá nhân'),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: ho_ten,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Họ tên',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: phone_number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        capNhatThongTinCaNhan(tTinUser.id, ho_ten.text,
                            email.text, phone_number.text);
                      },
                      child: const Text('Lưu thông tin'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    ChangePassword(user_info: tTinUser)));
                      },
                      child: const Text('Thay đổi mật khẩu'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategory(String categoryName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 30,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
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
