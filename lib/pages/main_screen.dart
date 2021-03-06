import 'package:flutter/material.dart';

import 'package:app_du_lich/pages/new_feed.dart';
import 'package:app_du_lich/pages/favorites.dart';
import 'package:app_du_lich/pages/home.dart';
import 'package:app_du_lich/pages/search_tab.dart';
import 'package:app_du_lich/pages/setting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  final screens = [
    const Search(),
    const Favorites(),
    const Home(),
    const NewFeed(),
    const Setting(),
  ];
  final items = <Widget>[
    const Icon(Icons.search),
    const Icon(Icons.favorite),
    const Icon(Icons.home),
    const Icon(FontAwesomeIcons.newspaper),
    const Icon(Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.green.shade300,
        body: screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            key: navigationKey,
            height: 60,
            color: Colors.blue.shade700,
            animationCurve: Curves.easeOut,
            animationDuration: const Duration(milliseconds: 300),
            buttonBackgroundColor: Colors.brown,
            backgroundColor: Colors.transparent,
            index: 2,
            items: items,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
