import 'package:flutter/material.dart';

class SendPlaceName extends StatefulWidget {
  const SendPlaceName({Key? key}) : super(key: key);

  @override
  _SendPlaceNameState createState() => _SendPlaceNameState();
}

class _SendPlaceNameState extends State<SendPlaceName> {
  final images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ với chúng tôi'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin về địa danh',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildTextField('Tên địa danh'),
            _buildTextField('Vùng'),
            _buildTextField('Miền'),
            _buildTextField('Mô tả'),
            _buildTextField('Các hoạt động nổi bật'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
            // Container(
            //   child: images == null
            //       ? Text('Không có hình ảnh nào dc chọn')
            //       : Image.file(images!,
            //           width: 160, height: 160, fit: BoxFit.cover),
            // ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Gửi'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
