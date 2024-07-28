import 'package:SoilApp/main.dart';
import 'package:flutter/material.dart';
import 'package:SoilApp/Auth/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SoilApp/Auth/HttpUtils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AppColors.dart';

class LoginAndRegisterPage extends StatefulWidget {
  const LoginAndRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginAndRegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginAndRegisterPage> {
  FirebaseAuthException error = FirebaseAuthException(code: '1');
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (authError) {
      print("auth--------------");
      print(authError.code);
      print(authError.message!);
      setState(() {
        error = authError;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      registerUserOnServer(_controllerEmail.text);
    } on FirebaseAuthException catch (authError) {
      print("auth--------------");
      print(authError.code);
      print(authError.message!);
      setState(() {
        error = authError;
      });
    }
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
  ) {
    return TextField(

      cursorColor: mainColor,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 2),
        ),

        labelText: title,
        labelStyle: const TextStyle(color: mainColor),
      ),
    );
  }

  Map<String, String> errorsInRussian = {
    "1": "",
    "email-already-in-use": "Пользователь с такой почтой уже существует",
    "channel-error": "Заполните оба поля",
    "invalid-email": "Неправильно введена почта",
    "invalid-credential": "Неправильная почта или пароль",
    "weak-password": "Пароль должнен быть не меньше 6 символов",
  };

  Widget _errorMessage() {
    print(error);
    print("solution = ${errorsInRussian[error.code.toString()]}");
    return Text(error.message == '' ? '': '${errorsInRussian[error.code.toString()]}');
  }

  Widget _submitButton() {
    return ElevatedButton.icon(
      onPressed:
        isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      icon:  Icon(isLogin ? Icons.login : Icons.app_registration, color: mainColor),
      label: Text(isLogin ? 'Войти' : 'Регистрация', style: GoogleFonts.ibmPlexSans(
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
    );

  }

  Widget _sizedBox() {
    return const SizedBox(height: 10);

  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Регистрация' : 'Войти', style: GoogleFonts.ibmPlexSans(
          color: mainColor
      )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorRegister,
      appBar: AppBar(
            backgroundColor: mainColor,
            leading: const Icon(Icons.camera, color: secondaryColor),
            title: Text("SoilApp", style: GoogleFonts.ibmPlexSans(
                fontWeight: FontWeight.bold,
                color: secondaryColor
              )
            )
        ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _entryField('Почта', _controllerEmail),
              _sizedBox(),
              _entryField('Пароль', _controllerPassword),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton(),
            ]
        ),
      ),
    );
  }
}
