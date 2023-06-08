import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/config.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../menu.dart';
import '../../widgets.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel(BuildContext context);
  bool isObscure = true;
  String? userType;
  int userProfile = 2;
  String? fio;
  String lastName = '';
  String firstName = '';
  String middleName = '';
  bool rememberMe = false;
  final storage = const FlutterSecureStorage();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> onReady() async {
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");
    String? check = await storage.read(key: "rememberCheck");
    rememberMe = check == 'true';
    rememberMe ? loginController.text = login! : loginController.text = '';
    rememberMe ? passwordController.text = password! : passwordController.text = '';
    notifyListeners();
  }

  void rememberFunc(bool? value) async {
    rememberMe = value ?? false;
    await storage.write(key: "rememberCheck", value: "$rememberMe");
    notifyListeners();
  }

  Future<void> authButton(BuildContext context) async {
    final response = await http.post(
      Uri.parse(Config.apiHost),
      body: {"login": loginController.text, "password": passwordController.text},
    );
    final tempToken = json.decode(response.body)['accessToken'];

    if (response.statusCode == 200) {
      var userData = json.decode(response.body)['userInfo'];
      userType = userData["userType"];
      userProfile = userType == 'сотрудник' ? 1 : 0;

      await storage.write(key: "tokenKey", value: tempToken);
      await storage.write(key: "login", value: loginController.text);
      await storage.write(key: "password", value: passwordController.text);
      await storage.write(key: "userType", value: userType);

      lastName = userData['lastName'];
      firstName = userData['firstName'];
      middleName = userData['middleName'];
      fio = '$lastName $firstName $middleName';
      await storage.write(key: "FIO", value: fio);
    }

    switch (response.statusCode) {
      case 200:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(
              type: userProfile,
            ),
          ),
        );
        break;
      case 400:
        errorDialog(context, 'Требуется логин/пароль пользователя!');
        break;
      case 401:
        errorDialog(context, 'Некорректный логин/пароль пользователя!');
        break;
      case 500:
        errorDialog(context, 'Ошибка сервера! Если ошибка не исчезнет обратитесь в отдел сопровождения');
        break;
      default:
        errorDialog(context, 'Непредвиденная ошибка! Если ошибка не исчезнет обратитесь в отдел сопровождения');
        break;
    }
    notifyListeners();
  }

  void isVisiblePassword() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
