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
  String sessionId = "";
  late bool state_email;
  late bool state_phonenumber;

  Iterable dsBaiViet = [];

  Future<void> layThongTinNgDung(String _user_id) async {
    await API(url: "http://10.0.2.2:8000/thong-tin-ng-dung/$_user_id")
        .getDataString()
        .then((value) => tTinUser = User.fromJson(json.decode(value)));
    if (tTinUser.state_email == 1) state_email = true;
    if (tTinUser.state_phonenumber == 1) state_phonenumber = true;
    setState(() {});
  }

  Future<void> updateStateEmail(String _user_id) async {
    await API(url: "http://10.0.2.2:8000/up-state-email/$_user_id")
        .getDataString();
  }

  Future<void> updateStateSdt(String _user_id) async {
    await API(url: "http://10.0.2.2:8000/up-state-phonenumber/$_user_id")
        .getDataString();
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

  getSessionId() async {
    dynamic response = await FlutterSession().get("userId");
    sessionId = response.toString();
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
        state_email: -1,
        phonenumber: "",
        state_phonenumber: -1);
    state_email = false;
    state_phonenumber = false;
    getSessionId();
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
                child: tTinUser.id.toString() == sessionId
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Informaition()));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.pen,
                          color: Colors.black,
                          size: 20,
                        ),
                      )
                    : null),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tTinUser.state_email != 1 &&
                                    tTinUser.state_phonenumber != 1 &&
                                    tTinUser.id.toString() == sessionId
                                ? 'Thông tin liên hệ'
                                : tTinUser.state_email != 1 &&
                                        tTinUser.state_phonenumber != 1
                                    ? ''
                                    : 'Thông tin liên hệ:',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            tTinUser.id.toString() == sessionId
                                ? 'Công khai'
                                : '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      tTinUser.state_phonenumber != 1 &&
                              tTinUser.id.toString() == sessionId
                          ? ListTile(
                              leading: const Icon(Icons.phone,
                                  size: 30, color: Colors.green),
                              title: Text(tTinUser.phonenumber,
                                  style: const TextStyle(fontSize: 18)),
                              trailing: tTinUser.id.toString() == sessionId
                                  ? Switch.adaptive(
                                      value: state_phonenumber,
                                      onChanged: (value) {
                                        updateStateSdt(tTinUser.id.toString());
                                        setState(() {
                                          state_phonenumber = value;
                                        });
                                      },
                                    )
                                  : null)
                          : tTinUser.state_phonenumber == 1
                              ? ListTile(
                                  leading: const Icon(Icons.phone,
                                      size: 30, color: Colors.green),
                                  title: Text(tTinUser.phonenumber,
                                      style: const TextStyle(fontSize: 18)),
                                  trailing: tTinUser.id.toString() == sessionId
                                      ? Switch.adaptive(
                                          value: state_phonenumber,
                                          onChanged: (value) {
                                            updateStateSdt(
                                                tTinUser.id.toString());
                                            setState(() {
                                              state_phonenumber = value;
                                            });
                                          },
                                        )
                                      : null)
                              : const SizedBox(),
                      tTinUser.state_email != 1 &&
                              tTinUser.id.toString() == sessionId
                          ? ListTile(
                              leading: const Icon(Icons.email,
                                  size: 30, color: Colors.red),
                              title: Text(tTinUser.email,
                                  style: const TextStyle(fontSize: 18)),
                              trailing: tTinUser.id.toString() == sessionId
                                  ? Switch.adaptive(
                                      value: state_email,
                                      onChanged: (value) {
                                        updateStateEmail(
                                            tTinUser.id.toString());
                                        setState(() {
                                          state_email = value;
                                        });
                                      },
                                    )
                                  : null)
                          : tTinUser.state_email == 1
                              ? ListTile(
                                  leading: const Icon(Icons.email,
                                      size: 30, color: Colors.red),
                                  title: Text(tTinUser.email,
                                      style: const TextStyle(fontSize: 18)),
                                  trailing: tTinUser.id.toString() == sessionId
                                      ? Switch.adaptive(
                                          value: state_email,
                                          onChanged: (value) {
                                            updateStateEmail(
                                                tTinUser.id.toString());
                                            setState(() {
                                              state_email = value;
                                            });
                                          },
                                        )
                                      : null)
                              : const SizedBox(),
                    ],
                  ),
                  dsBaiViet.length > 0
                      ? const Text(
                          'Bài viết:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox()
                ],
              ),
              ...(dsBaiViet
                  .map((baiviet) => ReView(baiViet: BaiViet.fromJson(baiviet))))
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
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              tTinUser.fullname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
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
