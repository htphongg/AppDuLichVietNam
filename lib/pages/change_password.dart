import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:app_du_lich/pages/login.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  User user_info;

  ChangePassword({Key? key, required this.user_info}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _matkhau_cu;
  late TextEditingController _matkhau_moi;
  late TextEditingController _cf_matkhau_moi;

  Iterable result = [];

  Future<void> doiMatKhau(
      int user_id, String old_pass, String new_pass, String cf_new_pass) async {
    await API(
            url:
                "http://10.0.2.2:8000/doi-mat-khau/$user_id/$old_pass/$new_pass/$cf_new_pass")
        .getDataString()
        .then((value) => result = json.decode(value));
    if (result.elementAt(0)["state"] == "true") {
      showAlertDialog(context, result.elementAt(0)["state"],
          result.elementAt(0)["message"]);
    } else
      showAlertDialog(context, result.elementAt(0)["state"],
          result.elementAt(0)["message"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _matkhau_cu = TextEditingController();
    _matkhau_moi = TextEditingController();
    _cf_matkhau_moi = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi mật khẩu'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin mật khẩu',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _matkhau_cu,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mật khẩu cũ',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _matkhau_moi,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mật khẩu mới',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _cf_matkhau_moi,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Xác nhận mật khẩu mới',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_matkhau_cu.text != '' &&
                      _matkhau_moi.text != '' &&
                      _cf_matkhau_moi.text != '') {
                    doiMatKhau(widget.user_info.id, _matkhau_cu.text,
                        _matkhau_moi.text, _cf_matkhau_moi.text);
                  } else
                    showAlertDialog(
                        context, "false", "Vui lòng nhập đầy đủ thông tin");
                },
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String state, String message) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      if (state == "true") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const Login()),
            (Route<dynamic> route) => false);
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
