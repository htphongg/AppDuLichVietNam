import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/hoat_dong.dart';
import 'package:app_du_lich/models/mien.dart';
import 'package:app_du_lich/models/vung.dart';
import 'package:flutter/material.dart';

class SendPlaceName extends StatefulWidget {
  const SendPlaceName({Key? key}) : super(key: key);

  @override
  _SendPlaceNameState createState() => _SendPlaceNameState();
}

class _SendPlaceNameState extends State<SendPlaceName> {
  Iterable dsMien = [];
  Iterable dsVung = [];
  Iterable dsHoatDong = [];
  Iterable resultSendPlaceName = [];

  String tenvung = '';
  String tenmien = '';
  String tenhoatdong = '';
  late TextEditingController ten_dia_danh;
  late TextEditingController mo_ta;
  late TextEditingController kinh_do;
  late TextEditingController vi_do;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> layDsMien() async {
    await API(url: "http://10.0.2.2:8000/ds-mien")
        .getDataString()
        .then((value) => dsMien = json.decode(value));
    if (!mounted) return;

    setState(() {});
  }

  Future<void> layDsVung() async {
    await API(url: "http://10.0.2.2:8000/ds-vung")
        .getDataString()
        .then((value) => dsVung = json.decode(value));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layDsHoatDong() async {
    await API(url: "http://10.0.2.2:8000/ds-hoat-dong")
        .getDataString()
        .then((value) => dsHoatDong = json.decode(value));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> guiDiaDanh(
      tendiadanh, mota, vung, mien, hoatdong, kinhdo, vido) async {
    await API(
            url:
                "http://10.0.2.2:8000/them-dia-danh-cho/$tendiadanh/$mota/$vung/$mien/$hoatdong/$kinhdo/$vido")
        .getDataString()
        .then((value) => resultSendPlaceName = json.decode(value));
    if (resultSendPlaceName.elementAt(0)["state"] == "true") {
      showAlertDialog(context, resultSendPlaceName.elementAt(0)["message"]);
    } else {
      showAlertDialog(context, resultSendPlaceName.elementAt(0)["message"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsVung();
    layDsMien();
    layDsHoatDong();
    ten_dia_danh = TextEditingController();
    mo_ta = TextEditingController();
    kinh_do = TextEditingController();
    vi_do = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ten_dia_danh.dispose();
    mo_ta.dispose();
    kinh_do.dispose();
    vi_do.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ với chúng tôi'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin về địa danh',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: ten_dia_danh,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên địa danh',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: mo_ta,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mô tả',
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: TextField(
                //     controller: path_avt,
                //     decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Đường dẫn ảnh đại diện',
                //     ),
                //   ),
                // ),
                _buildSelectListVung(),
                _buildSelectListMien(),
                _buildSelectListHoatDong(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: kinh_do,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kinh độ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: vi_do,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vĩ độ',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
                // Container(
                //   child: images == null
                //       ? Text('Không có hình ảnh nào dc chọn')
                //       : Image.file(images!,
                //           width: 160, height: 160, fit: BoxFit.cover),
                // ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (ten_dia_danh.text.isNotEmpty &&
                          mo_ta.text.isNotEmpty &&
                          kinh_do.text.isNotEmpty &&
                          vi_do.text.isNotEmpty &&
                          tenvung != '' &&
                          tenmien != '' &&
                          tenhoatdong != '') {
                        guiDiaDanh(ten_dia_danh.text, mo_ta.text, tenvung,
                            tenmien, tenhoatdong, kinh_do.text, vi_do.text);
                      } else
                        showAlertDialog(
                            context, "Vui lòng nhập đầy đủ thông tin");
                    },
                    child: const Text('Gửi cho quản trị viên'),
                  ),
                ),
                const SizedBox(height: 25)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVung(Vung vung) {
    return ListTile(
      title: Text(vung.ten_vung),
      onTap: () {
        tenvung = vung.ten_vung;
        setState(() {});
      },
    );
  }

  Widget _buildMien(Mien mien) {
    return ListTile(
      title: Text(mien.ten_mien),
      onTap: () {
        tenmien = mien.ten_mien;
        setState(() {});
      },
    );
  }

  Widget _buildHoatDong(HoatDong hoatDong) {
    return ListTile(
      title: Text(hoatDong.ten),
      onTap: () {
        tenhoatdong = hoatDong.ten;
        setState(() {});
      },
    );
  }

  Widget _buildSelectListVung() {
    return ExpansionTile(
      textColor: Colors.black87,
      iconColor: Colors.black87,
      backgroundColor: Colors.grey.shade100,
      title: const Text(
        "Vùng",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        tenvung,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
      ),
      children: [...(dsVung.map((vung) => _buildVung(Vung.fromJson(vung))))],
    );
  }

  Widget _buildSelectListMien() {
    return ExpansionTile(
      textColor: Colors.black87,
      iconColor: Colors.black87,
      backgroundColor: Colors.grey.shade100,
      title: const Text(
        "Miền",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        tenmien,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
      ),
      children: [...(dsMien.map((mien) => _buildMien(Mien.fromJson(mien))))],
    );
  }

  Widget _buildSelectListHoatDong() {
    return ExpansionTile(
      textColor: Colors.black87,
      iconColor: Colors.black87,
      backgroundColor: Colors.grey.shade100,
      title: const Text(
        "Hoạt động nổi bật",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        tenhoatdong,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
      ),
      children: [
        ...(dsHoatDong
            .map((hoatDong) => _buildHoatDong(HoatDong.fromJson(hoatDong))))
      ],
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
