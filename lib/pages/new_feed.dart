import 'dart:convert';

import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/bai_viet.dart';
import 'package:app_du_lich/pages/review_post.dart';
import 'package:flutter/material.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({Key? key}) : super(key: key);

  @override
  _NewFeedState createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  Iterable dsBaiVietJson = [];

  Future<void> layDsBaiViet() async {
    await API(url: "http://10.0.2.2:8000/ds-bai-viet")
        .getDataString()
        .then((value) => dsBaiVietJson = json.decode(value));
    setState(() {});
  }

  Future<void> refresh() async {
    await layDsBaiViet();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    layDsBaiViet();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(),
      child: Scaffold(
        backgroundColor: Colors.indigo.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Bài viết mới nhất'),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: dsBaiVietJson.length,
            itemBuilder: (context, index) {
              return ReView(
                  baiViet: BaiViet.fromJson(dsBaiVietJson.elementAt(index)));
            },
          ),
        ),
      ),
    );
  }
}
