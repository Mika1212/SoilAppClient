import 'package:SoilApp/Auth/Auth.dart';
import 'package:SoilApp/pages/MainPage.dart';
import 'package:SoilApp/pages/profile/LoginAndRegisterPage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        return const MainPage();
      } else {
        return const LoginAndRegisterPage();
      }
    },
    ); // StreamBuilder
  }
}
