import 'package:SoilApp/pages/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:SoilApp/pages/profile/ProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoilApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'IBM'
      ),
      home: const ProfilePage(),
    );

  }
}
