import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:SoilApp/Auth/Auth.dart';

import 'package:SoilApp/pages/AppColors.dart';

import '../Sample.dart';
import '../Utils.dart';

const String ipAddr = "192.168.0.109:8080";

Future<void> registerUserOnServer(String email) async {
  String endpoint = 'users/createUser';

  var url = Uri.http(ipAddr, endpoint);

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'email': email,
  };
  final response = await http.post(url, headers: headers);
}

Future<String> uploadPhoto(String base64String,
    bool groupMethod,
    bool colorCheckerPresence,
    bool colorSystemMunsell) async {
  String withoutColorChecker = 'upload/allMethods';
  String withColorChecker = 'upload/allMethods/colorChecker';
  String groupSend = colorCheckerPresence ? 'upload/groupMethod/colorChecker'
      : 'upload/groupMethod';

  String method = colorCheckerPresence ?
  withColorChecker :
  withoutColorChecker;
  method = groupMethod ? groupSend : method;
  var url = Uri.http(ipAddr, method);

  String email = await Auth()
      .getUser()
      .email;

  final body = {
    "base64Image": base64String,
    "munsell": colorSystemMunsell,
    "email": email,
    "colorChecker": colorCheckerPresence,
  };
  final jsonString = json.encode(body);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  print(DateTime.now().millisecondsSinceEpoch);
  final response = await http.post(url, headers: headers, body: jsonString);
  print(DateTime.now().millisecondsSinceEpoch);

  return response.body;
}


Future<String> sendRecordRequest(String email) async {
  String method = 'users/getUserSamplesDetails';
  var url = Uri.http(ipAddr, method);

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'email': email,
  };
  final response = await http.get(url, headers: headers);

  return response.body;
}

Future<void> deleteUserSampleExecute(Sample sample, String email) async {
  String method = 'users/deleteUserSample';

  var url = Uri.http(ipAddr, method);
  String sampleDate = await sample.realDate;

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'email': email,
    'sampleDate': sampleDate,
  };

  final response = await http.delete(url, headers: headers);
}