import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:SoilApp/Auth/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<File> uint8ListToImage(Uint8List editedImage, int i) async {
  Uint8List imageInUint8List = editedImage;
  final tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/images$i.png').create();
  file.writeAsBytesSync(imageInUint8List);
  return file;
}