import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/dia_danh.dart';
import 'package:app_du_lich/pages/place_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Iterable dsDiaDanhDaThich = [];

  Future<void> layDsDiaDanhDaThich() async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/lay-ds-dia-danh-da-thich/$_user_id")
        .getDataString()
        .then((value) => dsDiaDanhDaThich = json.decode(value));
    setState(() {});
  }

  Future<void> refresh() async {
    await layDsDiaDanhDaThich();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsDiaDanhDaThich();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yêu thích'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: dsDiaDanhDaThich.length > 0
              ? ListView(
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...dsDiaDanhDaThich.map((diadanh) =>
                            _buildDiaDanh(context, DiaDanh.fromJson(diadanh))),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
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
