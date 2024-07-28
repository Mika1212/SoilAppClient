import 'dart:convert';
import 'dart:io';

import 'package:SoilApp/Auth/HttpUtils.dart';
import 'package:SoilApp/pages/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SoilApp/Auth/Auth.dart';
import 'package:SoilApp/Utils.dart' show uint8ListToImage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:full_screen_image/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Sample.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePage createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> with TickerProviderStateMixin {

  final User? user = Auth().currentUser;
  final List<Sample> sampleList = [];

  Future<User?> getUser() async {
    return user;
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> _sendRecordRequest() async {
    String? email = user?.email;
    String response = await sendRecordRequest(email!);
    print(response);

    List<String> responseBody = response.toString().replaceAll("\"", "")
        .replaceAll(",;}", "").replaceAll(";}", "").replaceAll("[{", "")
        .replaceAll("]", "").split(",{");

    print(responseBody);
    int i = 0;

    //add no history version of response
    if (response.length > 2) {
      for (String line in responseBody) {
        String realDate = line.split("Z")[0];
        List<String> dividedTwoSides = line.split("Z:");
        List<String> showDate = [dividedTwoSides[0].split("T")[0],
          dividedTwoSides[0].split("T")[1].substring(0, 5)];
        List<String> data = dividedTwoSides[1].split(";");
        String colorChecker = data[0] == "true"
            ? "исп."
            : "не исп.";
        String Cvalue = "Cорг = ${data[1].split(",")[2].split(":")[1]}";
        String HSL = data[2] == "null" ? "HSL не вычислялся" : data[2];
        final image64 = base64Decode(data[3]);
        File file = await uint8ListToImage(image64, i);
        String Munsell = data[4] == "null" ? "Шкала Манселла не вычислялась"
            : data[4];
        setState(() {
          sampleList.add(Sample(
              realDate,
              showDate,
              colorChecker,
              Cvalue,
              HSL,
              file,
              Munsell,
              ""));
        });

        i++;
      }
    }

  }

  Future<void> deleteUserSample(Sample sample) async {
    await showDialog(context: context, builder: (context) =>
        AlertDialog(
            title: const Text("Удаление", style:TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor
            )),
            content: const Text("Вы уверены в том, что хотите удалить запрос?",
                style:TextStyle(
                    fontSize: 17
                )),
            actions: [
              TextButton(
                  onPressed: () {
                     Navigator.pop(context);
                     _deleteUserSampleExecute(sample);
                      },
                  child: const
                  Text("Да", style:TextStyle(
                      color: mainColor
                  ))),
              TextButton(
                  onPressed: () =>  Navigator.pop(context),
                  child: const Text("Нет", style:TextStyle(
                      color: mainColor
                  )))
            ]
        )
    );
  }

  Future<void> _deleteUserSampleExecute(Sample sample) async {
    setState(() {
      sampleList.remove(sample);
    });
    String? email = user?.email;
    deleteUserSampleExecute(sample, email!);
  }

  late AnimationController controller;

  @override
  initState() {
    _sendRecordRequest();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: false);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthBasic = MediaQuery.of(context).size.width;
    double heightBasic = MediaQuery.of(context).size.height;

    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          leading: const Icon(Icons.person, color: secondaryColor),
          title: Text("Профиль", style: GoogleFonts.ibmPlexSans(
              fontWeight: FontWeight.bold,
              color: secondaryColor
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          // list view to show images and list count
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Row(children: [
                Text('Почта: ${user?.email}', style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    color: mainColor
                  )
                ),

                Container(
                  alignment: Alignment.centerRight,
                  child:
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: redColor),
                      onPressed: () => signOut(),
                      child: const Icon(Icons.exit_to_app),
                  )
                ),
              ]),
              Text("История запросов", style: GoogleFonts.ibmPlexSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: mainColor),
              ),

              if (sampleList.isEmpty)
                SizedBox(
                  height: heightBasic / 1.7,
                  width: widthBasic / 2,

                  child: Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                      value: controller.value,
                    ),
                  ),
                ),
              SizedBox(
                  height: heightBasic / 50
              ),

              for (Sample sample in sampleList)
                Column(
                  children: [

                    Column(
                      children: [
                        Row (
                          children: [
                            Container (
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
                                  color: elementBackgroundColor,
                                  border: Border(
                                    bottom: BorderSide(width: 1, color: elementBackgroundColor),
                                    left: BorderSide(width: 1, color: elementBackgroundColor),
                                    top: BorderSide(width: 1, color: elementBackgroundColor),
                                  ),
                              ),
                              //color: Colors.blueGrey

                              height: heightBasic / 7,
                              width: widthBasic / 5,
                              alignment: Alignment.centerLeft,

                              child: Container(
                                  padding: EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    child: FullScreenWidget(
                                      backgroundColor: elementBackgroundColor,
                                      disposeLevel: DisposeLevel.Low,
                                      child: Image.file(sample.image)
                                    )
                                )
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
                                color: elementBackgroundColor,
                                border: Border(
                                  bottom: BorderSide(width: 1, color: elementBackgroundColor),
                                  right: BorderSide(width: 1, color: elementBackgroundColor),
                                  top: BorderSide(width: 1, color: elementBackgroundColor),
                                ),
                              ),
                              height: heightBasic / 7,
                              width: widthBasic / 1.47,
                              padding: EdgeInsets.all(3.0),
                              child: Text(sample.text, style: GoogleFonts.ibmPlexSans()),
                            ),
                            ]
                          ),
                          Row(
                            children: [
                              SizedBox(width: widthBasic / 1.5),
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: accentColor),
                                onPressed: () => deleteUserSample(sample),
                                child: const Icon(Icons.delete),
                              )
                            ],
                          )
                        ],
                  ),
                ],
              ),

              SizedBox(height: heightBasic / 40),
            ],
          ),
        ),
      ),
    );
  }
}
