import 'package:app_du_lich/pages/change_password.dart';
import 'package:flutter/material.dart';

class Informaition extends StatefulWidget {
  const Informaition({Key? key}) : super(key: key);

  @override
  _InformaitionState createState() => _InformaitionState();
}

class _InformaitionState extends State<Informaition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin cá nhân'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildCategory('Thông tin cá nhân'),
                _buildTextField('Họ tên'),
                _buildTextField('Số điện thoại'),
                _buildTextField('Email'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Lưu thông tin'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const ChangePassword()));
                      },
                      child: const Text('Thay đổi mật khẩu'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategory(String categoryName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 30,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
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
