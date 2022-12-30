import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/API/config.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../API/api_provider.dart';
import '../../../API/network_response.dart';
import '../../../API/routes/auth_route.dart';
import '../../menu.dart';
import '../../widgets.dart';
import 'auth_view.dart';

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
  final ApiProvider _apiProvider = ApiProvider();

  Future onReady() async {
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");
    String? check = await storage.read(key: "rememberCheck");
    check == 'true' ? rememberMe = true : rememberMe = false;
    rememberMe ? loginController.text = login! : loginController.text = '';
    rememberMe
        ? passwordController.text = password!
        : passwordController.text = '';
    notifyListeners();
  }

  rememberFunc(value) async {
    rememberMe = value;
    await storage.write(key: "rememberCheck", value: "$rememberMe");
    notifyListeners();
  }

  void authButton(context) async {
    final response = await http.post(Uri.parse(Config.apiHost), body: {
      "login": loginController.text,
      "password": passwordController.text
    });
    final tempToken = json.decode(response.body)['accessToken'];

    if (response.statusCode == 200) {
      var userData = json.decode(response.body)['userInfo'];
      userType = userData["userType"];
      userType == 'сотрудник' ? userProfile = 1 : userProfile = 0;

      await storage.write(key: "tokenKey", value: tempToken);
      await storage.write(key: "login", value: loginController.text);
      await storage.write(key: "password", value: passwordController.text);
      await storage.write(key: "userType", value: userType);

      lastName = userData['lastName'];
      firstName = userData['firstName'];
      middleName = userData['middleName'];
      fio = ('$lastName $firstName $middleName');
      await storage.write(key: "FIO", value: fio);
    }

    switch (response.statusCode) {
      case 200:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainMenu(
                      type: userProfile,
                    )));
        break;
      case 400:
        errorDialog(context, 'Требуется логин/пароль пользователя!');
        break;
      case 401:
        errorDialog(context, 'Некорректный логин/пароль пользователя!');
        break;
    }
    notifyListeners();
  }

  void isVisiblePassword() {
    if (isObscure) {
      isObscure = false;
    } else {
      isObscure = true;
    }
    notifyListeners();
  }
}
