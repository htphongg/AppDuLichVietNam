import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;
import 'package:app_du_lich/models/nha_tro.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsHotel extends StatefulWidget {
  final NhaTro nhaTro;

  DetailsHotel({Key? key, required this.nhaTro}) : super(key: key);

  @override
  _DetailsHotelState createState() => _DetailsHotelState();
}

class _DetailsHotelState extends State<DetailsHotel> {
  final _controller = CarouselController();
  int activeIndex = 0;

  var f = intl.NumberFormat("###,###,###", "en_US");

  Iterable dsHinhAnh = [];

  Future<void> layDsHinhAnhNhaTro(int nha_tro_id) async {
    await API(url: "http://10.0.2.2:8000/ds-anh-nha-tro/$nha_tro_id")
        .getDataString()
        .then((value) => dsHinhAnh = json.decode(value));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsHinhAnhNhaTro(widget.nhaTro.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text(widget.nhaTro.ten)),
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
                  widget.nhaTro.ten,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      f.format(widget.nhaTro.gia) + ' VNĐ',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      f.format(widget.nhaTro.gia + 50000) + ' VNĐ',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: Colors.black54),
                    ),
                  ],
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
                Text(widget.nhaTro.dia_chi),
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
                Text(widget.nhaTro.mo_ta),
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
}
