import 'package:flutter/material.dart';

class Coupon extends StatefulWidget {
  const Coupon({Key? key}) : super(key: key);

  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ưu đãi'),
      ),
      body: Column(
        children: [
          //header
          Container(
            margin: EdgeInsets.only(left: 6, right: 6),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Hot DEAL tháng',
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mã ưu đãi',
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.green,
              child: _buildListItem(),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: SizedBox(
              height: 152,
              child: _buildTListTicket(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem() {
    return ListView(
      children: <Widget>[
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        _buildItem(
            'images/restaurant/nhsg.jpg',
            'Hồ Chí Minh',
            'Buffet tại La Vela Saigon Hotel 5 Sao',
            'đ 750,000',
            'Từ 695,000 đ'),
        Container(
          margin: const EdgeInsets.all(15),
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              'Xem thêm',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(String ulrImage, String location, String name,
      String discount, String price) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: ListTile(
        isThreeLine: true,
        leading: Image.asset(
          ulrImage,
          height: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            location,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      discount,
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough, fontSize: 11),
                    ),
                    Text(
                      price,
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Đặt ngay',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTListTicket() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        TicketView('Giảm 100,000đ cho đơn hàng từ 1,000,000đ'),
        TicketView('5% OFF'),
        TicketView(
            'Giảm 110,000đ cho 3 hoặc 4 vé (đơn hàng khoảng 1,600,000đ) với số lượng có hạn.'),
      ],
    );
  }
}

class TicketView extends StatelessWidget {
  final String code;
  const TicketView(this.code);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
          content: Container(
            height: 100,
            child: Text(code),
          ),
          action: SnackBarAction(
            label: 'Ẩn',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: Colors.orange.shade500,
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text(
                    code,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.orange.shade500,
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          color: Colors.indigo.shade50),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => const SizedBox(
                                height: 1,
                                width: 5,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                            ),
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        color: Colors.indigo.shade50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 200,
              child: Container(
                margin: const EdgeInsets.only(left: 15, bottom: 10),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final snackBar = SnackBar(
                          content: Text('Đã lưu'),
                          action: SnackBarAction(
                            label: 'Ẩn',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        'Lưu mã',
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: Colors.orange.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
