import 'package:flutter/material.dart';

import 'package:app_du_lich/pages/login.dart';
import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:app_du_lich/pages/details_account.dart';
import 'package:app_du_lich/pages/send_place_name.dart';
import 'package:flutter_session/flutter_session.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

Future<void> setSession() async {
  await FlutterSession().set('userId', "");
}

class _SettingState extends State<Setting> {
  late User tTinUser;

  Future<void> layThongTinNgDung() async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(url: "http://10.0.2.2:8000/thong-tin-ng-dung/$_user_id")
        .getDataString()
        .then((value) => tTinUser = User.fromJson(json.decode(value)));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tTinUser = User(
        id: -1,
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
        automaticallyImplyLeading: false,
        title: ListTile(
          title: const Text(
            'Chào mừng',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          subtitle: Text(
            tTinUser.fullname,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          trailing: TextButton(
            onPressed: () {
              showAlertDialog(context, "Bạn có chắc muốn thoát ứng dụng?");
            },
            child: const Text(
              'Thoát',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            _buildPostTouristAttraction(),
            _buildLabel('Tài khoản của tôi'),
            _buildItemAccount(
                Icons.account_circle_rounded, 'Thông tin tài khoản'),
            _buildItem(Icons.credit_card, 'Thông tin thẻ đã lưu của tôi'),
            _buildItemTrailing(Icons.monetization_on, 'Số dư hiện tại', '0đ'),
            _buildItem(Icons.add_location, 'Khuyến mãi'),
            _buildItem(Icons.email_outlined, 'Hộp thư'),
            _buildLabel('Cài đặt'),
            _buildItemTrailing(Icons.language, 'Ngôn ngữ', 'Tiếng Việt'),
            _buildItem(Icons.doorbell_outlined, 'Thông báo'),
            _buildLabel('Thông tin'),
            _buildItem(Icons.help_center, 'Trung tâm Trợ giúp'),
            _buildItem(Icons.supervised_user_circle, 'Về chúng tôi'),
          ],
        ),
      ),
    );
  }

  //Xây dựng navbar đăng địa danh
  Widget _buildPostTouristAttraction() {
    return Container(
      height: 75,
      width: double.infinity,
      color: Colors.brown,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SendPlaceName()));
        },
        child: const ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('images/logo.png'),
          ),
          title: Text(
            'Chia sẻ với chúng tôi',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            'diadanh.com',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Icon(
            Icons.arrow_back_ios_rounded,
            textDirection: TextDirection.rtl,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //Xây dựng label
  Widget _buildLabel(String label) {
    return Container(
      height: 40,
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                label,
                style: const TextStyle(color: Colors.black38),
              ),
            )
          ],
        ),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
    );
  }

  //Xây dựng item
  Widget _buildItem(IconData icon, String title) {
    return GestureDetector(
      onTap: () {},
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(color: Colors.black38)),
      ),
    );
  }

  //Xây dựng item
  Widget _buildItemAccount(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    DetailsAccount(user_id: tTinUser.id.toString())));
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(color: Colors.black38)),
      ),
    );
  }

  Widget _buildItemTrailing(IconData icon, String title, String trailing) {
    return GestureDetector(
      onTap: () {},
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(color: Colors.black38)),
        trailing: Text(
          trailing,
          style: const TextStyle(color: Colors.black38),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  Widget okButton = TextButton(
    child: const Text("Thoát"),
    onPressed: () {
      Navigator.pop(context);
      setSession();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const Login()),
          (Route<dynamic> route) => false);
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("Huỷ bỏ"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Thông báo"),
    content: Text(message),
    actions: [okButton, cancelButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
