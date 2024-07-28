import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SoilApp/pages/AppColors.dart';

import 'HelpPageText.dart';


class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPage createState() => _HelpPage();
}

class _HelpPage extends State<HelpPage> {

  @override
  Widget build(BuildContext context) {
    double heightBasic = MediaQuery
        .of(context)
        .size
        .height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            leading: const Icon(Icons.help, color: secondaryColor),
            title: Text("Помощь", style: GoogleFonts.ibmPlexSans(
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
                SizedBox(height: heightBasic / 40),

                Text("Часто задаваемые вопросы", style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: mainColor),
                ),

                SizedBox(height: heightBasic / 40),

                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: elementBackgroundColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: elementBackgroundColor),
                      right: BorderSide(width: 1, color: elementBackgroundColor),
                      top: BorderSide(width: 1, color: elementBackgroundColor),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                  child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child:
                            Text(howToDoBetterPhotoHeaderText,
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: mainColor),
                            ),
                          ),
                        SizedBox(height: heightBasic / 70),

                        Container(
                          alignment: Alignment.centerLeft,
                          child:
                          Text(howToDoBetterPhotoText,
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 15),
                          ),
                        )
                      ]
                  )
                ),

                SizedBox(height: heightBasic / 40),

                Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: elementBackgroundColor,
                      border: Border(
                        bottom: BorderSide(width: 1, color: elementBackgroundColor),
                        right: BorderSide(width: 1, color: elementBackgroundColor),
                        top: BorderSide(width: 1, color: elementBackgroundColor),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                    child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(algorithmWorkHeaderText,
                              style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: mainColor),
                            ),
                          ),
                          SizedBox(height: heightBasic / 70),

                          Container(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(algorithmWorkText,
                              style: GoogleFonts.ibmPlexSans(
                                  fontSize: 15),
                            ),
                          )
                        ]
                    )
                ),

                SizedBox(height: heightBasic / 40),

                Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: elementBackgroundColor,
                      border: Border(
                        bottom: BorderSide(width: 1, color: elementBackgroundColor),
                        right: BorderSide(width: 1, color: elementBackgroundColor),
                        top: BorderSide(width: 1, color: elementBackgroundColor),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                    child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(communicateWithUsHeaderText,
                              style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: mainColor),
                            ),
                          ),
                          SizedBox(height: heightBasic / 70),

                          Container(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(communicateWithUsText,
                              style: GoogleFonts.ibmPlexSans(
                                  fontSize: 15),
                            ),
                          )
                        ]
                    )
                ),
                SizedBox(height: heightBasic / 40),

              ],
            ),
          ),
        )
    );
  }
}