import 'package:app_du_lich/pages/details_account.dart';
import 'package:app_du_lich/pages/place_name.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:app_du_lich/api.dart';
import 'package:app_du_lich/models/anh.dart';
import 'package:app_du_lich/models/bai_viet.dart';
import 'package:app_du_lich/models/user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../models/dia_danh.dart';

class ReView extends StatefulWidget {
  BaiViet baiViet;
  ReView({Key? key, required this.baiViet}) : super(key: key);

  @override
  _ReViewState createState() => _ReViewState();
}

class _ReViewState extends State<ReView> {
  late User ngViet;

  Iterable dsHinhAnh = [];
  Iterable resultYeuThich = [];
  Iterable resultKhongYeuThich = [];
  late DiaDanh diaDanh;

  bool post_liked = false;
  bool post_disliked = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> layThongTinNguoiViet(int user_id) async {
    await (API(
            url:
                "https://travellappp.herokuapp.com/thong-tin-nguoi-dung/$user_id"))
        .getDataString()
        .then((value) => ngViet = User.fromJson(json.decode(value)));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layTTinDiaDanh(int dia_danh_id) async {
    await API(url: "https://travellappp.herokuapp.com/dia-danh/$dia_danh_id")
        .getDataString()
        .then((value) => diaDanh = DiaDanh.fromJson(json.decode(value)));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layDsHinhAnh(int bai_viet_id) async {
    await API(
            url:
                "https://travellappp.herokuapp.com/ds-anh-bai-viet/$bai_viet_id")
        .getDataString()
        .then((value) => dsHinhAnh = json.decode(value));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> like(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/like-bai-viet/$bai_viet_id/$_user_id")
        .getDataString();
  }

  Future<void> unlike(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/unlike-bai-viet/$bai_viet_id/$_user_id")
        .getDataString();
  }

  Future<void> dislike(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/dislike/$bai_viet_id/$_user_id")
        .getDataString();
  }

  Future<void> undislike(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/undislike/$bai_viet_id/$_user_id")
        .getDataString();
  }

  Future<void> layTrangThaiThich(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/trang-thai-thich-bai-viet/$bai_viet_id/$_user_id")
        .getDataString()
        .then((value) => resultYeuThich = json.decode(value));
    if (resultYeuThich.elementAt(0)["state"] == "true") {
      post_liked = true;
      // widget.baiViet.luot_thich =
      //     (int.parse(widget.baiViet.luot_thich) - 1).toString();
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> layTrangThaiKhongThich(int bai_viet_id) async {
    dynamic response = await FlutterSession().get("userId");
    String _user_id = response.toString();
    await API(
            url:
                "https://travellappp.herokuapp.com/trang-thai-khong-thich-bai-viet/$bai_viet_id/$_user_id")
        .getDataString()
        .then((value) => resultKhongYeuThich = json.decode(value));
    if (resultKhongYeuThich.elementAt(0)["state"] == "true") {
      post_disliked = true;
    }
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
        state_email: -1,
        phonenumber: "",
        state_phonenumber: -1);
    diaDanh = DiaDanh(
        id: 0,
        avt: "",
        ten_dia_danh: "",
        mo_ta: "",
        luot_checkin: 0,
        luot_thich: 0,
        vung_id: 0,
        mien_id: 0,
        kinh_do: 0,
        vi_do: 0);
    layTrangThaiThich(widget.baiViet.id);
    layTrangThaiKhongThich(widget.baiViet.id);
    layThongTinNguoiViet(widget.baiViet.nguoi_dung_id);
    layTTinDiaDanh(widget.baiViet.dia_danh_id);
    layDsHinhAnh(widget.baiViet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => DetailsAccount(
                                    user_id: widget.baiViet.nguoi_dung_id
                                        .toString()))),
                        child: Text(ngViet.fullname),
                      ),
                      const Text(' đang ở')
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => PlaceName(diaDanh: diaDanh))),
                    child: Text(
                      diaDanh.ten_dia_danh,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                //HH:mm:ss
                child: Text(
                    DateFormat('dd-MM-yyyy').format(widget.baiViet.ngay_dang)),
              )),
          //Trạng thái đánh giá
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                RatingBarIndicator(
                  rating: double.parse(widget.baiViet.rate.toString()),
                  itemSize: 20,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 5),
                int.parse(widget.baiViet.rate.toString()) == 5
                    ? const Text('Rất hài lòng',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                    : int.parse(widget.baiViet.rate.toString()) == 4
                        ? const Text('Hơi hài lòng',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                        : int.parse(widget.baiViet.rate.toString()) == 3
                            ? const Text('Bình thường',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold))
                            : int.parse(widget.baiViet.rate.toString()) == 2
                                ? const Text('Không hài lòng',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                                : const Text('Rất không hài lòng',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
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
            child: ReadMoreText(
              widget.baiViet.noi_dung,
              style: const TextStyle(fontSize: 18),
              trimCollapsedText: 'Xem thêm',
              trimExpandedText: 'Thu gọn',
              trimMode: TrimMode.Length,
              trimLength: 100,
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

                      return SizedBox(
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
                          post_disliked
                              ? post_liked = false
                              : post_liked = true;
                          unlike(widget.baiViet.id);
                          setState(() {
                            post_liked ? post_liked = false : post_liked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Yêu thích'),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        onPressed: () {
                          if (post_disliked) {
                            post_disliked = false;
                            undislike(widget.baiViet.id);
                            like(widget.baiViet.id);
                          } else {
                            like(widget.baiViet.id);
                          }
                          setState(() {
                            post_liked ? post_liked = false : post_liked = true;
                          });
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Yêu thích'),
                      ),
                post_disliked
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade900),
                        onPressed: () {
                          undislike(widget.baiViet.id);
                          setState(() {
                            post_disliked
                                ? post_disliked = false
                                : post_disliked = true;
                          });
                        },
                        icon: const Icon(Icons.heart_broken_sharp),
                        label: const Text('Không yêu thích'),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        onPressed: () {
                          if (post_liked) {
                            post_liked = false;
                            unlike(widget.baiViet.id);
                            dislike(widget.baiViet.id);
                          } else {
                            dislike(widget.baiViet.id);
                          }
                          setState(() {
                            post_disliked
                                ? post_disliked = false
                                : post_disliked = true;
                          });
                        },
                        icon: const Icon(Icons.heart_broken_sharp),
                        label: const Text('Không yêu thích'),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
