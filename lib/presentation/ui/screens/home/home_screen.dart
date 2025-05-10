import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:eleaning/core/helper/color_helper.dart';

import 'package:eleaning/presentation/ui/screens/home/home_details.dart';
import 'package:eleaning/presentation/ui/screens/search/search_screen.dart';
import 'package:eleaning/presentation/ui/screens/student/profile.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<String> imagePath = [
    "assets/images/Home.png",
    "assets/images/Search.png",

    "assets/images/User.png",
  ];
  List<Map<String, dynamic>> screens = [
    {'screen': const HomeDetails()},
    {'screen': const SearchScreen()},

    {'screen': ProfileScreen()},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        itemCount: imagePath.length,
        tabBuilder: (index, isActive) {
          return Image(
            image: AssetImage(imagePath[index]),
            color: isActive ? ColorHelper.blue : ColorHelper.lightGrey,
          );
        },

        activeIndex: selectedIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        splashColor: ColorHelper.red,
        backgroundColor: ColorHelper.white,
        height: 10.h,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: screens[selectedIndex]['screen'],
        ),
        // ),
      ),
    );
  }
}
