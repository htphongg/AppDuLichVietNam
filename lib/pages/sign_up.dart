import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _username;
  late TextEditingController _password;
  late TextEditingController _cf_password;
  late TextEditingController _fullname;
  late TextEditingController _email;
  late TextEditingController _phone_number;

  bool isEmail = true;
  bool isPhone_Number = true;

  Iterable s = [];

  Future<void> dangKy(String _username, String _password, String _cf_password,
      String _fullname, String _email, String _phone_number) async {
    await API(
            url:
                "http://10.0.2.2:8000/sign-up/$_username/$_password/$_cf_password/$_fullname/$_email/$_phone_number")
        .getDataString()
        .then((value) {
      s = json.decode(value);
      if (s.elementAt(0)["state"] == "true")
        showAlertDialog(context, s.elementAt(0)["message"]);
      else
        showAlertDialog(context, s.elementAt(0)["message"]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
    _cf_password = TextEditingController();
    _fullname = TextEditingController();
    _email = TextEditingController();
    _phone_number = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _username.dispose();
    _password.dispose();
    _cf_password.dispose();
    _fullname.dispose();
    _email.dispose();
    _phone_number.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Image.asset('images/logo.png'),
                  ),
                  Text(
                    'Du lịch Việt Nam',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontFamily: 'RobotoLeuschke',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        'Đăng ký tài khoản:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _fullname,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Họ tên',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      errorText: isEmail ? null : 'Email không đúng định dạng.',
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phone_number,
                    decoration: const InputDecoration(
                      // errorText: isPhone_Number
                      //     ? null
                      //     : 'Số điện thoại không đúng định dạng.',
                      border: OutlineInputBorder(),
                      labelText: 'Số điện thoại',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên đăng nhập',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mật khẩu',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cf_password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Xác nhận mật khẩu',
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(135, 50),
                      maximumSize: const Size(135, 50),
                    ),
                    onPressed: () {
                      if (_username.text != "" &&
                          _password.text != "" &&
                          _cf_password.text != "" &&
                          _fullname.text != "" &&
                          _email.text != "" &&
                          _phone_number.text != "") {
                        setState(() {
                          !_email.text.contains("@")
                              ? isEmail = false
                              : isEmail = true;

                          // !_phone_number.text.contains("0") &&
                          //         _phone_number.text.length != 10
                          //     ? isPhone_Number = false
                          //     : isPhone_Number = true;
                        });
                        if (_email.text.contains("@")) {
                          dangKy(
                              _username.text,
                              _password.text,
                              _cf_password.text,
                              _fullname.text,
                              _email.text,
                              _phone_number.text);
                        }
                      } else
                        showAlertDialog(
                            context, "Vui lòng nhập đầy đủ thông tin.");
                    },
                    child: const Text(
                      'Đăng ký',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
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
