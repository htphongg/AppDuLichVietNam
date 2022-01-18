import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_du_lich/pages/information.dart';

class DetailsAccount extends StatefulWidget {
  const DetailsAccount({Key? key}) : super(key: key);

  @override
  _DetailsAccountState createState() => _DetailsAccountState();
}

class _DetailsAccountState extends State<DetailsAccount> {
  late double coverHeight = 280;
  late double profileHeight = 144;
  late double top = coverHeight - profileHeight / 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text(
            'Huỳnh Phong',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 26),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const Informaition()));
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
      body: ListView(
        children: [
          _buildWallpaper(),
          _buildNameAccount(),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Bài viết',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Bộ sưu tập',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAccount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Huỳnh Thanh Phong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'Đi đến những nơi thật đẹp',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(
            height: 26,
          ),
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
        backgroundImage: const AssetImage('images/meo.jpg'),
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
