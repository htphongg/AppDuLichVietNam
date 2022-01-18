import 'package:app_du_lich/pages/list_hot_place_name.dart';
import 'package:app_du_lich/pages/list_new_place_name.dart';
import 'package:app_du_lich/pages/search_page.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Hot gần đây'),
    const Tab(text: 'Mới nhất'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Có gì mới?'),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const Icon(Icons.search)),
            )
          ],
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            Hot_Place_Name(),
            ListNew_PlaceName(),
          ],
        ),
      ),
    );
  }
}
