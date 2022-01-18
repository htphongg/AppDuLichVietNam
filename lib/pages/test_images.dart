import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

Iterable dsHinhAnh = [];

Future<void> layDsHinhAnh(int dia_danh_id) async {
  await API(url: "http://10.0.2.2:8000/ds-hinh-anh/$dia_danh_id")
      .getDataString()
      .then((value) {
    dsHinhAnh = json.decode(value);
  });
}

class _TestState extends State<Test> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsHinhAnh(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                layDsHinhAnh(1);
              });
            },
            child: const Text("Hiện"),
          ),
          dsHinhAnh.length > 0
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                          'http://10.0.2.2:8000/images/chua-mot-cot.jpg');
                    },
                    itemCount: dsHinhAnh.length,
                  ),
                )
              : const Text("Không có ảnh"),
        ],
      ),
    );
  }
}
