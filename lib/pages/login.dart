import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/pages/main_screen.dart';
import 'package:app_du_lich/pages/sign_up.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _username;
  late TextEditingController _password;

  Iterable s = [];

  Future<void> setSession(String id) async {
    await FlutterSession().set('userId', id);
  }

  Future<void> dangNhap(String _username, String _password) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/login/$_username/$_password")
        .getDataString()
        .then((value) {
      s = json.decode(value);
      if (s.elementAt(0)["state"] == "true") {
        setSession(s.elementAt(1)["id"].toString());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => MainScreen()),
            (Route<dynamic> route) => false);
      } else {
        showAlertDialog(context, s.elementAt(0)["message"]);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _username.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Image.asset('images/logo.png'),
                ),
                Text(
                  'Du l???ch Vi???t Nam',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontFamily: 'RobotoLeuschke'),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      TextField(
                        controller: _username,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'T??n ????ng nh???p',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'M???t kh???u',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(135, 50),
                          maximumSize: const Size(135, 50),
                        ),
                        onPressed: () {
                          if (_username.text != "" && _password.text != "") {
                            dangNhap(_username.text, _password.text);
                          } else {
                            showAlertDialog(context,
                                "Vui l??ng nh???p ?????y ????? th??ng tin t??i kho???n.");
                          }
                        },
                        child: const Text(
                          '????ng nh???p',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('B???n ch??a c?? t??i kho???n?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => const SignUp(),
                                ),
                              );
                            },
                            child: const Text('????ng k?? ngay.'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Your life style',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                            fontFamily: 'RobotoLeuschke'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
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
    title: const Text("Th??ng b??o"),
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
