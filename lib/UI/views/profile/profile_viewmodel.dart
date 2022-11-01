import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../API/config.dart';
import '../auth/auth_view.dart';
import '../iais/iais_view.dart';
import '../debts/debts_view.dart';
import '../checkList/checkList_view.dart';

class EnumUserType {
  static String get student => "обучающийся";
  static String get employee => "сотрудник";
}

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);

  final storage = const FlutterSecureStorage();

  String firstName = '';
  String lastName = '';
  String middleName = '';
  String email = '';
  String? phone = '';
  String group = '';
  String speciality = '';
  String faculty = '';
  String course = '';
  String qualification = '';
  String learnForm = '';
  String statusSTR = '';
  String finForm = '';
  String startYear = '';
  String debtData = '';
  String userType = '';
  int? userTypeInt;
  String jobTitle = '';
  String department = '';
  String fio = '';

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");

    var dio = Dio();

    final responseAuth = await dio.post(Config.apiHost, data: {
      "login": loginController.text,
      "password": passwordController.text
    });

    var userData = responseAuth.data['userInfo'];
    userType = userData["userType"];
    email = userData["email"];
    phone = userData["phone"];

    if (userType == EnumUserType.student) {
      firstName = userData["firstName"];
      lastName = userData["lastName"];
      middleName = userData["middleName"];
      final responseStudent = await dio
          .get(Config.studCardHost, queryParameters: {"accessToken": token});

      var studentCard = responseStudent.data[0];
      group = studentCard["GROUP_NAME"];
      speciality = studentCard["SPECIALITY"];
      faculty = studentCard["FACULTY"];
      qualification = studentCard["QUALIFICATION"];
      learnForm = studentCard["LEARN_FORM"];
      statusSTR = studentCard["STATUS_STR"];
      finForm = studentCard["FINFORM"];

      await storage.write(key: "firstName", value: firstName);
      await storage.write(key: "lastName", value: lastName);
      await storage.write(key: "middleName", value: middleName);
      await storage.write(key: "group", value: group);

      final responseMoneyDebt = await dio
          .get(Config.studMoneyDebt, queryParameters: {"accessToken": token});
      var moneyDebt = responseMoneyDebt.data["debtInfo"];
      if (moneyDebt["DEBT_AMOUNT"] == null) {
        debtData = "Отсутствует";
      } else {
        debtData = moneyDebt["DEBT_AMOUNT"].toString() +
            " (на дату: " +
            moneyDebt["DEBT_DATE"] +
            ")";
      }
    } else if (userType == EnumUserType.employee) {
      final responseEmployee = await dio
          .get(Config.empCardHost, queryParameters: {"accessToken": token});

      var employeeCard = responseEmployee.data["empList"][0];
      firstName = employeeCard["FIRST_NAME"];
      lastName = employeeCard["LAST_NAME"];
      middleName = employeeCard["MIDDLE_NAME"];
      jobTitle = employeeCard["POST_NAME"];
      department = employeeCard["DEP"];

      await storage.write(key: "firstName", value: firstName);
      await storage.write(key: "lastName", value: lastName);
      await storage.write(key: "middleName", value: middleName);
      await storage.write(key: "jobTitle", value: jobTitle);
      await storage.write(key: "department", value: department);

    }
    fio = ('$lastName $firstName $middleName');

    await storage.write(key: "fio", value: fio);
    await storage.write(key: "email", value: phone);
    await storage.write(key: "phone", value: phone);

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

  void debtsButton(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DebtsView()));
    notifyListeners();
  }

  void checklistButton(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CheckListView()));
    notifyListeners();
  }
}
