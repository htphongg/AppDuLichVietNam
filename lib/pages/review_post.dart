import 'package:app_du_lich/pages/details_account.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/anh.dart';
import 'package:app_du_lich/models/bai_viet.dart';
import 'package:app_du_lich/models/user.dart';

class ReView extends StatefulWidget {
  BaiViet baiViet;
  ReView({Key? key, required this.baiViet}) : super(key: key);

  @override
  _ReViewState createState() => _ReViewState();
}

class _ReViewState extends State<ReView> {
  late User ngViet;

  Iterable dsHinhAnh = [];

  bool post_liked = false;
  bool post_disliked = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> layThongTinNguoiViet(int user_id) async {
    await (API(url: "http://10.0.2.2:8000/thong-tin-nguoi-dung/$user_id"))
        .getDataString()
        .then((value) => ngViet = User.fromJson(json.decode(value)));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layDsHinhAnh(int bai_viet_id) async {
    await API(url: "http://10.0.2.2:8000/ds-anh-bai-quyet/$bai_viet_id")
        .getDataString()
        .then((value) => dsHinhAnh = json.decode(value));
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ngViet = User(
        id: 0,
        avt: "",
        username: "",
        password: "",
        fullname: "",
        email: "",
        phonenumber: "",
        display_state: "");
    layThongTinNguoiViet(widget.baiViet.nguoi_dung_id);
    layDsHinhAnh(widget.baiViet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Tên và avt
          ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(ngViet.avt)),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => DetailsAccount(
                              user_id:
                                  widget.baiViet.nguoi_dung_id.toString())));
                },
                child: Text(ngViet.fullname),
              ),
              subtitle: Text(widget.baiViet.ngay_dang.toString())),
          //Trạng thái đánh giá
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow.shade700),
                Icon(Icons.star, color: Colors.yellow.shade700),
                Icon(Icons.star, color: Colors.yellow.shade700),
                Icon(Icons.star, color: Colors.yellow.shade700),
                const SizedBox(width: 10),
                const Text(
                  'Rất hài lòng',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //Nội dung đánh giá

          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              widget.baiViet.tieu_de,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              widget.baiViet.noi_dung,
              style: const TextStyle(fontSize: 18),
            ),
          ),

          //Hình ảnh bài đánh giá
          dsHinhAnh.length > 0
              ? GridView.count(
                  padding: const EdgeInsets.all(15),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    ...(dsHinhAnh.map((hinhAnh) {
                      final anh = Anh.fromJson(hinhAnh);
                      return Container(
                        height: 24,
                        child: Image.network(
                          anh.path,
                          fit: BoxFit.cover,
                        ),
                      );
                    }))
                  ],
                )
              : const SizedBox(),
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 5),
                post_liked
                    ? Text(
                        "Bạn và " + widget.baiViet.luot_thich + " người khác",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                    : Text(widget.baiViet.luot_thich + " lượt yêu thích",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                post_liked
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade900),
                        onPressed: () {
                          setState(() {
                            post_liked ? post_liked = false : post_liked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Hữu ích'),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        onPressed: () {
                          setState(() {
                            post_liked ? post_liked = false : post_liked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Hữu ích'),
                      ),
                post_disliked
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade900),
                        onPressed: () {
                          setState(() {
                            post_disliked
                                ? post_disliked = false
                                : post_disliked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Không hữu ích'),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        onPressed: () {
                          setState(() {
                            post_disliked
                                ? post_disliked = false
                                : post_disliked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Không hữu ích'),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
