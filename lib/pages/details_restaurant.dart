import 'package:app_du_lich/pages/details_food.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/mon_an.dart';
import 'package:app_du_lich/models/quan_an.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsRestaurant extends StatefulWidget {
  final QuanAn quanAn;

  DetailsRestaurant({Key? key, required this.quanAn}) : super(key: key);

  @override
  _DetailsRestaurantState createState() => _DetailsRestaurantState();
}

class _DetailsRestaurantState extends State<DetailsRestaurant> {
  final _controller = CarouselController();
  int activeIndex = 0;

  Iterable dsHinhAnh = [];
  Iterable dsMonAn = [];

  Future<void> layDsHinhAnhQuanAn(int quan_an_id) async {
    await API(url: "https://travellappp.herokuapp.com/ds-anh-quan/$quan_an_id")
        .getDataString()
        .then((value) => dsHinhAnh = json.decode(value));
    setState(() {});
  }

  Future<void> layDsMonAn(int quan_an_id) async {
    await API(
            url: "https://travellappp.herokuapp.com/ds-mon-an-quan/$quan_an_id")
        .getDataString()
        .then((value) => dsMonAn = json.decode(value));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsHinhAnhQuanAn(widget.quanAn.id);
    layDsMonAn(widget.quanAn.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text(widget.quanAn.ten)),
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
                          final image_present =
                              dsHinhAnh.elementAt(index)["path"];
                          //
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.network('$image_present'),
                          );
                        },
                        options: CarouselOptions(
                          initialPage: 0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          height: 200,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 8),
              _buildIndicator(),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.quanAn.ten,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                  subtitle: Text('14 đánh giá'),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Địa chỉ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(widget.quanAn.dia_chi),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mô tả:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(widget.quanAn.mo_ta),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: const [
                Text(
                  'Các món ăn gợi ý:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...(dsMonAn.map((monan) {
                  return _buildMonAn(MonAn.fromJson(monan));
                })),
              ],
            ),
          ),
          const SizedBox(height: 20),
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

  Widget _buildMonAn(MonAn monan) {
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
                          f.format(int.parse(monan.gia)) + ' VNĐ',
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
}
