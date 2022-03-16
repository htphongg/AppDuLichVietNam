import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:flutter/services.dart';

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
  bool submitted = false;

  Iterable s = [];

  Future<void> dangKy(String _username, String _password, String _cf_password,
      String _fullname, String _email, String _phone_number) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/sign-up/$_username/$_password/$_cf_password/$_fullname/$_email/$_phone_number")
        .getDataString()
        .then((value) {
      s = json.decode(value);
      if (s.elementAt(0)["state"] == "true") {
        showAlertDialog(
            context, s.elementAt(0)["state"], s.elementAt(0)["message"]);
      } else
        showAlertDialog(
            context, s.elementAt(0)["state"], s.elementAt(0)["message"]);
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

  void _submit() {
    setState(() {
      submitted = true;
    });
    if (errorTextFullname == null &&
        errorTextEmail == null &&
        errorTextPhoneNumber == null &&
        errorTextUsername == null &&
        errorTextPassword == null &&
        errorTextCFPassword == null) {
      dangKy(_username.text, _password.text, _cf_password.text, _fullname.text,
          _email.text, _phone_number.text);
    }
  }

  String? get errorTextFullname {
    final text = _fullname.value.text;

    if (text.isEmpty) return 'Họ tên không được để trống.';

    return null;
  }

  String? get errorTextEmail {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    final text = _email.value.text;

    if (text.isEmpty) return 'Email không được để trống.';
    if (!regex.hasMatch(text)) return 'Email không đúng định dạng.';

    return null;
  }

  String? get errorTextPhoneNumber {
    String pattern = r'(84|0[3|5|7|8|9])+([0-9]{8})\b';
    RegExp regex = RegExp(pattern);
    final text = _phone_number.value.text;

    if (text.isEmpty) return 'Số điện thoại không được để trống.';

    if (!regex.hasMatch(text)) return 'Số điện thoại không đúng định dạng.';

    return null;
  }

  String? get errorTextPassword {
    final text = _password.value.text;

    if (text.isEmpty) return 'Mật khẩu không được để trống.';
    if (text.length < 6) return 'Mật khẩu phải có từ 6 kí tự trở lên.';

    return null;
  }

  String? get errorTextCFPassword {
    final text = _cf_password.value.text;

    if (text.isEmpty) return 'Xác nhận mật khẩu không được để trống.';
    if (text.length < 6) return 'Xác nhận mật khẩu phải có từ 6 kí tự trở lên.';

    return null;
  }

  String? get errorTextUsername {
    final text = _username.value.text;

    if (text.isEmpty) return 'Tên đăng nhập không được để trống.';
    if (text.length < 7) return 'Tên đăng nhập phải từ 7 kí tự.';

    return null;
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
                    onChanged: (_) => setState(() {}),
                    controller: _fullname,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Họ tên',
                        errorText: submitted ? errorTextFullname : null),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _email,
                    decoration: InputDecoration(
                      errorText: submitted ? errorTextEmail : null,
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _phone_number,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Số điện thoại',
                      errorText: submitted ? errorTextPhoneNumber : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _username,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Tên đăng nhập',
                      errorText: submitted ? errorTextUsername : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Mật khẩu',
                        errorText: submitted ? errorTextPassword : null),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _cf_password,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Xác nhận mật khẩu',
                        errorText: submitted ? errorTextCFPassword : null),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(135, 50),
                      maximumSize: const Size(135, 50),
                    ),
                    onPressed: () {
                      _submit();
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
