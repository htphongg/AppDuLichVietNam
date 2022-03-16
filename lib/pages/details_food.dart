import 'package:app_du_lich/models/quan_an.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:intl/intl.dart' as intl;
import 'package:app_du_lich/models/mon_an.dart';
import 'package:app_du_lich/pages/details_restaurant.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsFood extends StatefulWidget {
  final MonAn monan;

  DetailsFood({Key? key, required this.monan}) : super(key: key);

  @override
  _DetailsFoodState createState() => _DetailsFoodState();
}

class _DetailsFoodState extends State<DetailsFood> {
  final _controller = CarouselController();
  int activeIndex = 0;

  var f = intl.NumberFormat("###,###,###", "en_US");

  Iterable dsHinhAnh = [];
  Iterable dsQuanAn = [];

  Future<void> layDsHinhAnh(int mon_an_id) async {
    await API(url: "https://travellappp.herokuapp.com/ds-anh-mon/$mon_an_id")
        .getDataString()
        .then((value) => dsHinhAnh = json.decode(value));
    setState(() {});
  }

  Future<void> layDsQuan(int dia_danh_id) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/ds-quan-an-dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => dsQuanAn = json.decode(value));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsHinhAnh(widget.monan.id);
    layDsQuan(widget.monan.dia_danh_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text(widget.monan.ten)),
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
                Text(
                  widget.monan.ten,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      f.format(int.parse(widget.monan.gia)) + ' VNĐ',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      f.format(int.parse(widget.monan.gia + 30000.toString())) +
                          ' VNĐ',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: Colors.black54),
                    ),
                  ],
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
                  'Mô tả món:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(widget.monan.mo_ta)
              ],
            ),
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
            subtitle: const Text('14 đánh giá'),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: const [
                Text(
                  'Quán ăn gần đây:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 180,
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...(dsQuanAn.map(
                    (quanan) => _buildQuanAn(context, QuanAn.fromJson(quanan))))
              ],
            ),
          ),
          const SizedBox(height: 50),
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

Widget _buildQuanAn(BuildContext context, QuanAn quanan) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => DetailsRestaurant(quanAn: quanan)));
    },
    child: Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
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
          height: 60,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
  );
}
