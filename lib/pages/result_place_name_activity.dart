import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/dia_danh.dart';
import 'package:app_du_lich/models/hoat_dong.dart';
import 'package:app_du_lich/pages/place_name.dart';
import 'package:flutter/material.dart';

class ResultPlaceName_Activity extends StatefulWidget {
  final HoatDong hoatDong;
  const ResultPlaceName_Activity({Key? key, required this.hoatDong})
      : super(key: key);

  @override
  _ResultPlaceName_ActivityState createState() =>
      _ResultPlaceName_ActivityState();
}

class _ResultPlaceName_ActivityState extends State<ResultPlaceName_Activity> {
  Iterable dsDiaDanh = [];

  Future<void> layDsDiaDanhTheoHoatDong(int hoat_dong_id) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/ds-dia-danh-hoat-dong/$hoat_dong_id")
        .getDataString()
        .then((value) => dsDiaDanh = json.decode(value));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsDiaDanhTheoHoatDong(widget.hoatDong.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hoatDong.ten),
      ),
      body: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: dsDiaDanh.length > 0
              ? ListView(
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...dsDiaDanh.map((diadanh) =>
                            _buildDiaDanh(context, DiaDanh.fromJson(diadanh))),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              : const Center(child: CircularProgressIndicator())),
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
          width: 165,
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
          width: 165,
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
