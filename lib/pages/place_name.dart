import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/dia_danh.dart';
import 'package:app_du_lich/pages/details_restaurant.dart';
import 'package:app_du_lich/pages/review_post.dart';
import 'package:app_du_lich/pages/write_review_post.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:map_launcher/map_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app_du_lich/models/mon_an.dart';
import 'package:app_du_lich/models/nha_tro.dart';
import 'package:app_du_lich/models/quan_an.dart';
import 'package:app_du_lich/pages/details_food.dart';
import 'package:app_du_lich/pages/details_hotel.dart';
import 'package:app_du_lich/models/bai_viet.dart';

class PlaceName extends StatefulWidget {
  late DiaDanh diaDanh;

  PlaceName({Key? key, required this.diaDanh}) : super(key: key);

  @override
  _PlaceNameState createState() => _PlaceNameState();
}

class _PlaceNameState extends State<PlaceName> {
  final _controller = CarouselController();
  int activeIndex = 0;
  bool liked = false;

  Iterable resultLikeState = [];
  Iterable dsHinhAnh = [];
  Iterable dsMonAn = [];
  Iterable dsQuanAn = [];
  Iterable dsNhaTro = [];
  Iterable dsBaiViet = [];

  Future<void> layDsHinhAnh(int dia_danh_id) async {
    await API(url: "http://10.0.2.2:8000/ds-hinh-anh/$dia_danh_id")
        .getDataString()
        .then((value) {
      dsHinhAnh = json.decode(value);
    });
    setState(() {});
  }

  Future<void> layDsMonAn(int dia_danh_id) async {
    await API(url: "http://10.0.2.2:8000/ds-mon-an-dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => dsMonAn = json.decode(value));
    setState(() {});
  }

  Future<void> layDsQuanAn(int dia_danh_id) async {
    await API(url: "http://10.0.2.2:8000/ds-quan-an-dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => dsQuanAn = json.decode(value));
    setState(() {});
  }

  Future<void> layDsNhaTro(int dia_danh_id) async {
    await API(url: "http://10.0.2.2:8000/ds-nha-tro-dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => dsNhaTro = json.decode(value));
    setState(() {});
  }

  Future<void> layDsBaiViet(int dia_danh_id) async {
    await API(url: "http://10.0.2.2:8000/ds-bai-viet-dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => dsBaiViet = json.decode(value));
    setState(() {});
  }

  Future<void> like(int dia_danh_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();

    await API(url: "http://10.0.2.2:8000/like/$dia_danh_id/$_user_id")
        .getDataString();
    setState(() {});
  }

  Future<void> unlike(int dia_danh_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(url: "http://10.0.2.2:8000/unlike/$dia_danh_id/$_user_id")
        .getDataString();
    setState(() {});
  }

  Future<void> trangThaiThich(int dia_danh_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url: "http://10.0.2.2:8000/trang-thai-thich/$dia_danh_id/$_user_id")
        .getDataString()
        .then((value) => resultLikeState = json.decode(value));

    if (resultLikeState.elementAt(0)["state"] == "true")
      liked = true;
    else
      liked = false;
    setState(() {});
  }

  void openMap(DiaDanh diaDanh) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(diaDanh.kinh_do, diaDanh.vi_do),
      title: diaDanh.ten_dia_danh,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trangThaiThich(widget.diaDanh.id);
    layDsHinhAnh(widget.diaDanh.id);
    layDsQuanAn(widget.diaDanh.id);
    layDsMonAn(widget.diaDanh.id);
    layDsNhaTro(widget.diaDanh.id);
    layDsBaiViet(widget.diaDanh.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text(widget.diaDanh.ten_dia_danh)),
      body: ListView(
        children: [
          Column(
            children: [
              dsHinhAnh.length > 0
                  ? Container(
                      child: CarouselSlider.builder(
                        carouselController: _controller,
                        itemCount: dsHinhAnh.length,
                        itemBuilder: (context, index, readIndex) {
                          final image_path = dsHinhAnh.elementAt(index)["path"];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.network('$image_path'),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          initialPage: 0,
                          height: 200,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              _buildIndicator(),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.diaDanh.ten_dia_danh,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text(
                      widget.diaDanh.luot_checkin.toString() +
                          " người đã Checkin tại đây.",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('Checkin ngay',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900)),
                  ),
                ),
                const SizedBox(height: 10),
                resultLikeState.length > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          liked
                              ? SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Bạn và " +
                                        widget.diaDanh.luot_thich.toString() +
                                        " người khác thích địa điểm này.",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Text(
                                  widget.diaDanh.luot_thich.toString() +
                                      " người thích địa điểm này.",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade300),
                            onPressed: () {
                              liked
                                  ? unlike(widget.diaDanh.id)
                                  : like(widget.diaDanh.id);
                              setState(() {
                                liked ? liked = false : liked = true;
                              });
                            },
                            icon: liked
                                ? const Icon(
                                    Icons.thumb_up_outlined,
                                    size: 30,
                                    color: Colors.blue,
                                  )
                                : const Icon(Icons.thumb_up_outlined,
                                    size: 30, color: Colors.black),
                            label: liked
                                ? const Text('Đã thích',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue))
                                : const Text('Thích',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                          )
                        ],
                      )
                    : const SizedBox(),
                Container(
                  child: TextButton(
                    child: const Text(
                      'Xem trên bản đồ',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      openMap(widget.diaDanh);
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Text(
                    '4.9',
                    style: TextStyle(fontSize: 50),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      Icon(Icons.star, color: Colors.yellow.shade700)
                    ],
                  ),
                  subtitle: const Text('14 đánh giá'),
                ),
                const Divider(),
                const Text(
                  'Mô tả:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(widget.diaDanh.mo_ta,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  children: const [
                    Text(
                      'Các món đặc sản:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                dsMonAn.length > 0
                    ? Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...(dsMonAn.map((monan) {
                              return _buildMonAn(
                                  context, MonAn.fromJson(monan));
                            }))
                          ],
                        ),
                      )
                    : const Center(
                        child:
                            Text('Không tìm thấy món ăn đặc sản nào ở đây.')),
                const Divider(),
                Row(
                  children: const [
                    Text(
                      'Quán ăn gần đây:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                dsQuanAn.length > 0
                    ? Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...(dsQuanAn.map((quanan) {
                              return _buildQuanAn(
                                  context, QuanAn.fromJson(quanan));
                            }))
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Không tìm thấy quán ăn nào gần đây.')),
                const Divider(),
                Row(
                  children: const [
                    Text(
                      'Khách sạn gần đây:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                dsNhaTro.length > 0
                    ? Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...(dsNhaTro.map((nhatro) {
                              return _buildNhaTro(
                                  context, NhaTro.fromJson(nhatro));
                            }))
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Không tìm thấy khách sạn nào gần đây.')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.award),
                    const SizedBox(width: 5),
                    const Text(
                      'Đánh giá',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 75),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange.shade900),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const WirteReviewPost()));
                      },
                      child: const Text(
                        'Viết bài đánh giá',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                dsBaiViet.length > 0
                    ? Column(
                        children: [
                          ...(dsBaiViet.map((baiviet) =>
                              ReView(baiViet: BaiViet.fromJson(baiviet))))
                        ],
                      )
                    : const Center(
                        child: Text('Chưa có bài đánh giá nào.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    void animateToSlide(int index) => _controller.animateToPage(index);
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: dsHinhAnh.length,
      onDotClicked: animateToSlide,
      effect: SlideEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: Colors.green.shade400,
          dotColor: Colors.black12),
    );
  }
}

Widget _buildMonAn(BuildContext context, MonAn monan) {
  var f = intl.NumberFormat("###,###,###", "en_US");

  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => DetailsFood(monan: monan)));
    },
    child: Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                monan.avt,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white),
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    monan.ten,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.format(monan.gia) + ' VNĐ',
                        style: const TextStyle(color: Colors.red),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            size: 10,
                            color: Colors.yellow,
                          ),
                          Text(
                            '4.0',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            ' (999+)',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildQuanAn(BuildContext context, QuanAn quanan) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => DetailsRestaurant(quanAn: quanan)));
    },
    child: Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                quanan.avt,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white),
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    quanan.ten,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.star,
                        size: 10,
                        color: Colors.yellow,
                      ),
                      Text(
                        '4.0',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        ' (999+)',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildNhaTro(BuildContext context, NhaTro nhatro) {
  var f = intl.NumberFormat("###,###,###", "en_US");

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => DetailsHotel(nhaTro: nhatro)));
    },
    child: Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                nhatro.avt,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white),
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    nhatro.ten,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.format(nhatro.gia) + ' VNĐ',
                        style: const TextStyle(color: Colors.red),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.star,
                            size: 10,
                            color: Colors.yellow,
                          ),
                          Text(
                            '4.0',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            ' (999+)',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
