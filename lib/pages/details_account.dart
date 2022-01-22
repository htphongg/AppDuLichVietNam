import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/bai_viet.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:app_du_lich/pages/review_post.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_du_lich/pages/information.dart';

class DetailsAccount extends StatefulWidget {
  String user_id;

  DetailsAccount({Key? key, required this.user_id}) : super(key: key);

  @override
  _DetailsAccountState createState() => _DetailsAccountState();
}

class _DetailsAccountState extends State<DetailsAccount> {
  late double coverHeight = 280;
  late double profileHeight = 144;
  late double top = coverHeight - profileHeight / 2;
  late User tTinUser;

  Iterable dsBaiViet = [];

  Future<void> layThongTinNgDung(String _user_id) async {
    await API(url: "http://10.0.2.2:8000/thong-tin-ng-dung/$_user_id")
        .getDataString()
        .then((value) => tTinUser = User.fromJson(json.decode(value)));
    setState(() {});
  }

  Future<void> layDsBaiViet(String _user_id) async {
    await API(url: "http://10.0.2.2:8000/ds-bai-viet-ng-dung/$_user_id")
        .getDataString()
        .then((value) => dsBaiViet = json.decode(value));
    setState(() {});
  }

  Future<void> refresh() async {
    await layThongTinNgDung(widget.user_id);
    await layDsBaiViet(widget.user_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tTinUser = User(
        id: 0,
        avt: "",
        username: "",
        password: "",
        fullname: "",
        email: "",
        phonenumber: "",
        display_state: "");
    layThongTinNgDung(widget.user_id);
    layDsBaiViet(widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(),
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Text(tTinUser.fullname,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 26),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => Informaition()));
                },
                icon: const Icon(
                  FontAwesomeIcons.pen,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.blue.shade300,
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: ListView(
            children: [
              _buildWallpaper(),
              _buildNameAccount(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin liên hệ:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.phone, size: 30, color: Colors.green),
                    title: Text(tTinUser.phonenumber,
                        style: const TextStyle(fontSize: 18)),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.email, size: 30, color: Colors.red),
                    title: Text(tTinUser.email,
                        style: const TextStyle(fontSize: 18)),
                  ),
                  const Text(
                    'Bài viết:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ...(dsBaiViet.map(
                  (baiviet) => ReView(baiViet: BaiViet.fromJson(baiviet)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameAccount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              tTinUser.fullname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Đi đến những nơi thật đẹp',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  Widget _buildWallpaper() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: _buildAvatarImage(),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileHeight / 2 - 5,
        backgroundImage: NetworkImage(tTinUser.avt),
      ),
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey.shade400,
      child: Image.asset(
        'images/location/kh.jpg',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}
