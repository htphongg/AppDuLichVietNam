import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WirteReviewPost extends StatefulWidget {
  const WirteReviewPost({Key? key}) : super(key: key);

  @override
  _WirteReviewPostState createState() => _WirteReviewPostState();
}

class _WirteReviewPostState extends State<WirteReviewPost> {
  File? images;

  // Future pickImage() async {
  //   try {
  //     final images = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (images == null) return;

  //     final imageTemp = File(images.path);
  //     setState(() {
  //       this.images = imageTemp;
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to pick images: $e');
  //   }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá địa danh'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                  Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                  Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                  Icon(Icons.star, color: Colors.yellow.shade700, size: 40),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade700,
                    size: 40,
                  )
                ],
              ),
              GestureDetector(
                // onTap: () => pickImage(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: 200,
                  height: 80,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_enhance, size: 40),
                      Text(
                        'Thêm hình ảnh',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: images == null
                    ? const Text('Không có hình ảnh nào dc chọn')
                    : Image.file(images!,
                        width: 160, height: 160, fit: BoxFit.cover),
              ),
              Container(
                child: TextFormField(
                  minLines: 3,
                  maxLength: 500,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Chia sẻ điều bạn thích về địa danh này nhé.',
                    labelStyle: TextStyle(fontSize: 18),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(onPressed: () {}, child: Text('Đăng')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
