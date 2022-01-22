import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/dia_danh.dart';
import 'package:app_du_lich/pages/place_name.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ScrollController _scrollController = ScrollController();
  // int currentMax = 3;

  Iterable dsDiaDanhJson = [];
  List<DiaDanh> dsDiaDanh = [];
  List<DiaDanh> dsDiaDanhTimThay = [];
  List<DiaDanh> dsHienThi = [];

  bool findMode = false;

  Future<void> layDsDiaDanh() async {
    await API(url: "http://10.0.2.2:8000/ds-dia-danh")
        .getDataString()
        .then((value) {
      dsDiaDanhJson = json.decode(value);
    });
    dsDiaDanhJson.forEach((diaDanh) {
      dsDiaDanh.add(DiaDanh.fromJson(diaDanh));
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsDiaDanh();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _getMoreDiaDanh();
    //   }
    // });
  }

  // _getMoreDiaDanh() {
  //   for (int i = currentMax; i < currentMax + 3; i++) {
  //     dsHienThi.add(dsDiaDanhTimThay[i]);
  //   }
  //   currentMax += 3;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The search area here
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              onSubmitted: (value) {
                if (value != '') {
                  findMode = true;
                  dsDiaDanhTimThay = [];
                  dsDiaDanh.forEach((diaDanh) {
                    if (diaDanh.ten_dia_danh
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                      dsDiaDanhTimThay.add(diaDanh);
                  });
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  hintText: 'Bạn cần tìm gì?',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        color: Colors.grey.shade200,
        child: dsDiaDanhTimThay.length > 0
            ? ListView(
                // controller: _scrollController,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...dsDiaDanhTimThay
                          .map((diadanh) => _buildDiaDanh(context, diadanh)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : findMode
                ? const Center(
                    child: Text(
                      'Không tìm thấy kết quả nào !',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : null,
      ),
    );
  }
}

Widget _buildDiaDanh(BuildContext context, DiaDanh diadanh) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => PlaceName(diaDanh: diadanh)));
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
