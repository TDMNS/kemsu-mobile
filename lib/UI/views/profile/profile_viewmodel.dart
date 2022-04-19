import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../API/config.dart';
import '../auth/auth_view.dart';
import '../iais/iais_view.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();
  String firstName = '';
  String lastName = '';
  String middleName = '';
  String email = '';
  String? phone;
  String group = '';
  String speciality = '';
  String faculty = '';
  String course = '';
  String qualification = '';
  String learnForm = '';
  String statusSTR = '';
  String finForm = '';
  String startYear = '';

  int selectedIndex = 2;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();
    final response2 = await dio.post(Config.apiHost, data: {
      "login": loginController.text,
      "password": passwordController.text
    });
    var userData = response2.data['userInfo'];
    firstName = userData["firstName"];
    lastName = userData["lastName"];
    middleName = userData["middleName"];
    email = userData["email"];
    phone = userData["phone"];

    final response1 = await dio
        .get(Config.studCardHost, queryParameters: {"accessToken": token});
    var studentCard = response1.data[0];
    group = studentCard["GROUP_NAME"];
    speciality = studentCard["SPECIALITY"];
    faculty = studentCard["FACULTY"];
    qualification = studentCard["QUALIFICATION"];
    learnForm = studentCard["LEARN_FORM"];
    statusSTR = studentCard["STATUS_STR"];
    finForm = studentCard["FINFORM"];
    //print(response1.data);

    notifyListeners();
  }

  void exitButton(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthView()));
    notifyListeners();
  }

  void iaisButton(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const IaisView()));
    notifyListeners();
  }
}
