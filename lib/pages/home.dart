import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/dia_danh.dart';
import 'package:app_du_lich/models/mien.dart';
import 'package:app_du_lich/models/vung.dart';
import 'package:app_du_lich/pages/place_name.dart';
import 'package:app_du_lich/pages/result_place_name_domain.dart';
import 'package:app_du_lich/pages/result_place_name_region.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app_du_lich/models/hoat_dong.dart';
import 'package:app_du_lich/pages/result_place_name_activity.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = CarouselController();
  int activeIndex = 0;

  Iterable dsDiaDanh = [];
  Iterable dsDiaDanhHot = [];
  List<DiaDanh> lst = [];

  Iterable dsMien = [];
  Iterable dsVung = [];
  Iterable dsHoatDong = [];

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> layDsDiaDanh() async {
    await API(url: "http://10.0.2.2:8000/ds-dia-danh")
        .getDataString()
        .then((value) {
      dsDiaDanh = json.decode(value);
    });
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layDsDiaDanhHot() async {
    await API(url: "http://10.0.2.2:8000/ds-dia-danh-hot")
        .getDataString()
        .then((value) {
      dsDiaDanhHot = json.decode(value);
    });
    lst = [];
    dsDiaDanhHot.forEach((element) {
      lst.add(DiaDanh.fromJson(element));
    });
    if (!mounted) return;

    setState(() {});
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

  Future<void> refresh() async {
    await layDsDiaDanh();
    // await layDsDiaDanhHot();
    // await layDsMien();
    // await layDsVung();
    // await layDsHoatDong();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsDiaDanh();
    layDsDiaDanhHot();
    layDsMien();
    layDsVung();
    layDsHoatDong();
  }

  final listBanner = [
    Image.asset('images/banner/mientay.jpg'),
    Image.asset('images/banner/mt.jpg'),
    Image.asset('images/banner/sea.jpg'),
    Image.asset('images/banner/vietnam.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(),
      child: Scaffold(
          appBar: AppBar(title: const Text('Trang chủ')),
          body: Container(
            color: Colors.grey.shade200,
            height: double.infinity,
            child: ListView(
              children: [
                _buildTitle('Xách ba lô lên và đi nào !'),
                _buildBanner(),
                _buildTitle('Địa điểm hot gần đây'),
                //Start - slider
                dsDiaDanhHot.length > 0
                    ? Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: _controller,
                            itemCount: lst.length,
                            itemBuilder: (context, index, readIndex) {
                              final image_path = lst[index].avt;
                              return _buildImageDiaDanhHot(
                                  image_path, lst[index]);
                            },
                            options: CarouselOptions(
                              initialPage: 0,
                              height: 250,
                              autoPlay: true,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              autoPlayInterval: const Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildIndicator(),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
                //End - slider
                const SizedBox(height: 15),
                _buildTitle('Khám phá'),
                dsDiaDanh.length > 0
                    ? Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...(dsDiaDanh.map((diadanh) =>
                                _buildDiaDanh(DiaDanh.fromJson(diadanh)))),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
              ],
            ),
          ),
          drawer: Drawer(child: _builDrawer())),
    );
  }

  Widget _buildDiaDanh(DiaDanh diadanh) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlaceName(diaDanh: diadanh)));
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: 180,
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
                diadanh.avt,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 120,
            width: 180,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  title: Text(
                    diadanh.ten_dia_danh,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      diadanh.mo_ta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
                      Text(
                        diadanh.luot_thich.toString() + " lượt thích",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 105,
      child: CarouselSlider.builder(
        itemCount: listBanner.length,
        itemBuilder: (context, index, readIndex) {
          final image_present = listBanner[index];
          return _buildImage(image_present, index);
        },
        options: CarouselOptions(
          autoPlay: true,
          enableInfiniteScroll: false,
          viewportFraction: 1,
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImage(Image image_present, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: image_present,
    );
  }

  Widget _buildImageDiaDanhHot(String image_path, DiaDanh diadanh) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlaceName(diaDanh: diadanh)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Image.network('$image_path'),
      ),
    );
  }

  Widget _buildIndicator() {
    void animateToSlide(int index) => _controller.animateToPage(index);
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: lst.length,
      onDotClicked: animateToSlide,
      effect: SlideEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: Colors.green.shade400,
          dotColor: Colors.black12),
    );
  }

  Widget _builDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('images/logo.png'),
                backgroundColor: Colors.white10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Du lịch Việt Nam',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        // color: Colors.orange.shade900,
                        color: Colors.blue.shade900,
                        fontFamily: 'RobotoLeuschke'),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.searchLocation,
            color: Colors.blue.shade700,
          ),
          title: Text(
            'Tìm nhanh',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700),
          ),
        ),
        ExpansionTile(
          textColor: Colors.black87,
          iconColor: Colors.black87,
          backgroundColor: Colors.grey.shade100,
          title: const Text(
            'Miền',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'Các địa danh theo miền',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
          ),
          children: [
            ...(dsMien.map((mien) => _buildMien(context, Mien.fromJson(mien))))
          ],
        ),
        ExpansionTile(
          textColor: Colors.black87,
          iconColor: Colors.black87,
          backgroundColor: Colors.grey.shade100,
          title: const Text(
            'Vùng',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'Các địa danh theo vùng',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
          children: [
            ...(dsVung.map((vung) => _buildVung(context, Vung.fromJson(vung))))
          ],
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.hotjar, color: Colors.blue.shade700),
          title: Text(
            'Các hoạt động nổi bật',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700),
          ),
        ),
        ...(dsHoatDong.map((hoatDong) =>
            _buildHoatDong(context, HoatDong.fromJson(hoatDong)))),
        const SizedBox(height: 60)
      ],
    );
  }
}

Widget _buildMien(BuildContext context, Mien mien) {
  return ListTile(
    title: Text(mien.ten_mien),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => ResultPlaceName_Domain(mien: mien)));
    },
  );
}

Widget _buildVung(BuildContext context, Vung vung) {
  return ListTile(
    title: Text(vung.ten_vung),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => ResultPlaceName_Region(vung: vung)));
    },
  );
}

Widget _buildHoatDong(BuildContext context, HoatDong hoatDong) {
  return ListTile(
    title: Text(hoatDong.ten),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  ResultPlaceName_Activity(hoatDong: hoatDong)));
    },
  );
}
