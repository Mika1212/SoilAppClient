import 'dart:io';

class Sample {
  String realDate;
  List<String> showDate;
  String colorChecker;
  String Cvalue;
  String HSL;
  File image;
  String Munsell;
  String text;

  Sample(this.realDate, this.showDate, this.colorChecker, this.Cvalue,
      this.HSL, this.image, this.Munsell, this.text) {
    text = makeTextAboutSample();
  }

  String makeTextAboutSample() {
    return
        "${showDate[0]} ${showDate[1]}\n"
        "Цветовая карта $colorChecker\n"
        "$Cvalue\n"
        "$HSL\n"
        "$Munsell";
  }
}