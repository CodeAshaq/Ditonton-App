import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tv/presentation/pages/tv/home_tv_page.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({ Key? key }) : super(key: key);
  static const routeName = '/bottom_nav';

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _indexBottomNav = 0;

  final List<Widget> pageOptions = [
    HomeMoviePage(),
    HomeTVSeriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions.elementAt(_indexBottomNav),
      backgroundColor: Color.fromARGB(197, 14, 0, 51),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: SalomonBottomBar(
          onTap: (index) {
            setState(() {
              _indexBottomNav = index;
            });
          },
          currentIndex: _indexBottomNav,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.movie),
              title: const Text("Movies"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.tv_rounded),
              title: const Text("TV Series"),
            ),
          ],
          unselectedItemColor: Color.fromARGB(255, 46, 46, 46),
          selectedItemColor: Colors.white,
        ),
      ),
      );
  }
}