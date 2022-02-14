import 'package:app_du_lich/pages/login.dart';
import 'package:app_du_lich/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _user_id = '';

  Future<void> getSession() async {
    dynamic response = await FlutterSession().get("userId");
    _user_id = response.toString();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Du lịch Việt Nam',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _user_id == 'null' || _user_id == ''
            ? const Login()
            : MainScreen());
  }
}
