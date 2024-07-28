import 'package:flutter/material.dart';
import 'package:SoilApp/pages/profile/UserProfilePage.dart';

import 'package:SoilApp/pages/AppColors.dart';
import 'CameraPage.dart';
import 'HelpPage.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<MainPage> {

  final List<Widget> pages = [
    const HelpPage(),
    const CameraPage(),
    UserProfilePage(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainColor,
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,

        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.help,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
