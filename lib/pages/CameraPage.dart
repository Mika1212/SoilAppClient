import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:SoilApp/Auth/HttpUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:SoilApp/pages/AppColors.dart';

import '../Utils.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPage createState() => _CameraPage();
}


class _CameraPage extends State<CameraPage> {

  File? _imgFile;
  String? base64String;
  var organicCarbon = [];
  bool colorCheckerPresence = false;
  bool colorSystemMunsell  = false;

  Future<String> takeSnapshot(bool galleryOrCamera) async {
    String answer = "";
    if (colorCheckerPresence) {
      await remindAboutColorChecker();
    }
    for (int i = 0; i < 2; i++) {
      if (i == 1) {
        await remindAboutTakingPhoto();
      }
      final ImagePicker picker = ImagePicker();

      final XFile? img = galleryOrCamera ? await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
      )
          : await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
      );

      if (img == null) return "";

      imageCache.clear();
      setState(() {
        _imgFile = File(img.path); // convert it to a Dart:io file
      });

      final editedImage = await editImage(_imgFile!);
      if (editedImage.isNotEmpty) {
        File file = await uint8ListToImage(editedImage, 0);
        setState(() {
          _imgFile = file;
        });
      }
      answer += base64Encode(editedImage);
      if (!colorCheckerPresence) return answer;
      if (i == 0) {
        answer += ";";
      }
    }
    return answer;
  }

  Future<Uint8List> editImage(File imgFile) async {
    Uint8List imageBytes = File(_imgFile!.path).readAsBytesSync();
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: imageBytes, // <-- Uint8List of images
        ),
      ),
    );
    return editedImage;
  }

  Future<void> _uploadPhoto(String base64String, bool groupMethod) async {
    String response = await uploadPhoto(base64String, groupMethod,
        colorCheckerPresence, colorSystemMunsell);
    List<String> responseArr = response.split(";");

    double avg = double.parse(
        responseArr[2].split(":")[1].replaceAll(",", "."));

    if (colorSystemMunsell) {
      String MunsellH =
          responseArr[3].split(":")[1].replaceAll(",", ".");
      double MunsellV = double.parse(
          responseArr[4].split(":")[1].replaceAll(",", "."));
      double MunsellC = double.parse(
          responseArr[5].split(":")[1].replaceAll(",", "."));
      double HSLH = double.parse(
          responseArr[6].split(":")[1].replaceAll(",", "."));
      double HSLS = double.parse(
          responseArr[7].split(":")[1].replaceAll(",", "."));
      double HSLL = double.parse(
          responseArr[8].split(":")[1].replaceAll(",", "."));

      showDialog(context: context, builder: (context) =>
          AlertDialog(
              title: const Text("Результаты", style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: mainColor)),
                  content: Text(
                    "Cорг, avg = $avg\n"
                    "\nПо шкале Манселла:\n"
                    "H = $MunsellH\n"
                    "V = $MunsellV\n"
                    "C = $MunsellC\n"
                    "\nВ цветовом пространстве HSL:\n"
                    "H = $HSLH\n S = $HSLS\n L = $HSLL"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Выход", style:TextStyle(
                      color: mainColor
                      )
                    )
                )
              ]
          )
      );
    } else {
      showDialog(context: context, builder: (context) =>
          AlertDialog(

              title: const Text("Результаты", style:TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mainColor
              )),
              content: Text("Cорг, avg = $avg\n",
                  style: const TextStyle(
                fontSize: 17
              )),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Выход", style:TextStyle(
                      color: mainColor
                      )
                    )
                )
              ]
          )
      );
    }
  }

  void loadPhotoThenSend(bool galleryOrCamera) async {
    String str = await takeSnapshot(galleryOrCamera);
    if (str != "") {
      _uploadPhoto(str, false);
    }
  }

  void loadSeriesOfPhotosThenSend() async {
    int amountOfPhotos = await askAboutPhotosAmount();
    String base64Image = "";
    for (int i = 0; i < amountOfPhotos; i++) {
      String str = await takeSnapshot(true);
      base64Image += "$str;";
    }
    if (base64Image != "") {
      _uploadPhoto(base64Image, true);
    }
  }

  Future<int> askAboutPhotosAmount() async{
    int amountOfPhotos = 0;
    await showDialog(context: context, builder: (context) =>
        AlertDialog(
            title: const Text("Количество фотографий", style:TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor
            )),
            content: const Text("Вы выбрали загрузку серии фото. "
                "Пожалуйста, выберите число фотогорафий, которые вы хотите загрузить.",
                style:TextStyle(
                  fontSize: 17
            )),
            actions: [
              DropdownMenu(
                  onSelected: (amountOfPhotosChosen) {
                    if (amountOfPhotosChosen != null) {
                      setState(() {
                        amountOfPhotos = amountOfPhotosChosen;
                      });
                    }
                  },
                  dropdownMenuEntries: const <DropdownMenuEntry<int>>[
                    DropdownMenuEntry(value: 2, label: "2"),
                    DropdownMenuEntry(value: 3, label: "3"),
                    DropdownMenuEntry(value: 4, label: "4"),
                    DropdownMenuEntry(value: 5, label: "5"),
                  ]
              ),
              TextButton(
                  onPressed: () =>  Navigator.pop(context),
                  child: const Text("Ок", style:TextStyle(
                    color: mainColor
                  )))
            ]
        )
    );
    return amountOfPhotos;
  }

  Future<void> remindAboutColorChecker() async{
    await showDialog(context: context, builder: (context) =>
        AlertDialog(
            title: const Text("Цветовая карта", style:TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor
            )),
            content: const Text("Вы выбрали использование цветовой карты. "
                "Пожалуйста, выберите на ней красный цвет.", style:TextStyle(
                fontSize: 17
            )),
            actions: [
              TextButton(
                  onPressed: () =>  Navigator.pop(context),
                  child: const Text("Ок", style:TextStyle(
                    color: mainColor
                )))
            ]
        )
    );
  }

  Future<void> remindAboutTakingPhoto() async{
    await showDialog(context: context, builder: (context) =>
        AlertDialog(
            title: const Text("Фото", style:TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor
            )),
            content: const Text("Сейчас необходимо выбрать/сделать фото почвы",
                style:TextStyle(
                fontSize: 17
            )),
            actions: [
              TextButton(
                  onPressed: () =>  Navigator.pop(context),
                  child: const Text("Ок", style:TextStyle(
                    color: mainColor
                  )))
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthBasic = MediaQuery.of(context).size.width;
    double heightBasic = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: const Icon(Icons.camera, color: secondaryColor),
        title: Text("SoilApp", style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.bold,
            color: secondaryColor
        )),
      ),
      body: Stack(
        children: [
          Positioned(
            left: widthBasic / 2 / 4,
            top: 0,
            child: _imgFile == null
                ? SizedBox(
                    height: heightBasic / 2,
                    width: (widthBasic - 2/8 * widthBasic),
                    child: Image.asset('lib/images/base_soil_2.jpg')
                  )
                : SizedBox(
                    height: heightBasic / 2,
                    width: (widthBasic - 2/8 * widthBasic),
                    child: Image.file(File(_imgFile!.path)),
            ),
          ),
          Positioned(
            left: widthBasic / 10,
            top: heightBasic / 2,
            width: widthBasic / 2 - widthBasic / 10,
            child:
            ElevatedButton.icon(
                onPressed: () => loadPhotoThenSend(true),
                icon: const Icon(Icons.photo, color: mainColor),
                label: Text('Загрузить фото', style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    color: mainColor
                  )
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            right: widthBasic / 10,
            top: heightBasic / 2,
            width: widthBasic / 2 - widthBasic / 8.5,
            child:
            ElevatedButton.icon(
                onPressed: () => loadPhotoThenSend(false),
                icon: const Icon(Icons.camera_alt_rounded, color: mainColor),
                label: Text('Сделать фото', style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    color: mainColor
                    )
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
              ),
            ),
          ),
          Positioned(
            left: widthBasic / 10,
            top: heightBasic / 2 + heightBasic / 15,
            right: widthBasic / 10,
            child:
            ElevatedButton.icon(
                onPressed: () => loadSeriesOfPhotosThenSend(),
                icon: const Icon(Icons.camera_alt_rounded, color: mainColor),
                label: Text('Загрузить серию фото', style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    color: mainColor
                  )
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ),
          Positioned(
              left: widthBasic / 6,
              top: heightBasic / 2 + heightBasic / 7.5,
              width: widthBasic - widthBasic / 3,
              child:
            CheckboxListTile(
              checkColor: secondaryColor,
              activeColor: mainColor,
              title: Text("Цветовая карта", style: GoogleFonts.ibmPlexSans(
                  fontWeight: FontWeight.bold,
                  color: mainColor
              )),
              value: colorCheckerPresence,
              onChanged: (newValue) {
                setState(() {
                  colorCheckerPresence = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            )
          ),
          Positioned(
              left: widthBasic / 6,
              top: heightBasic / 2 + heightBasic / 5,
              width: widthBasic - widthBasic / 3,
              child:
              CheckboxListTile(
                checkColor: secondaryColor,
                activeColor: mainColor,
                title: Text("Шкала Манселла", style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.bold,
                    color: mainColor
                )),
                value: colorSystemMunsell,
                onChanged: (newValue) {
                  setState(() {
                    colorSystemMunsell = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )
          ),
        ],
      ),
    );
  }
}
