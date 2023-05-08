import 'dart:convert';
import 'dart:io';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../auth/auth_view.dart';
import '../info/info_view.dart';
import '../debts/debts_view.dart';
import '../check_list/check_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class EnumUserType {
  static String get student => "обучающийся";
  static String get employee => "сотрудник";
}

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);

  int selectedIndex = 1;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final storage = const FlutterSecureStorage();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();

  String firstName = '';
  String lastName = '';
  String middleName = '';
  String email = '';
  String phone = '';
  String group = '';
  String speciality = '';
  String faculty = '';
  String course = '';
  String qualification = '';
  String learnForm = '';
  String statusSTR = '';
  String finForm = '';
  String startYear = '';
  String userType = '';
  int? userTypeInt;
  String jobTitle = '';
  String department = '';
  String fio = '';
  File? imageFile;
  String? img64;
  File? file;
  File? localImage;
  bool darkTheme = false;
  String? avatar;

  saveImage() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final fileName = basename(imageFile!.path);
    await imageFile!.copy('$appDocPath/$fileName');
    file = File('$appDocPath/$fileName');
    await storage.write(key: "avatar", value: file!.path);

    notifyListeners();
  }

  changeTheme(value) {
    darkTheme = value;
    notifyListeners();
  }

  getThemeToMain() {
    notifyListeners();
    return darkTheme;
  }

  prolongToken(context) async {
    String? token = await storage.read(key: 'tokenKey');
    final responseToken = await http.post(Uri.parse(Config.proLongToken), body: {"accessToken": token});
    responseToken.statusCode == 401
        ? Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthView()))
        : null;
    var newToken = json.decode(responseToken.body)['accessToken'];
    await storage.write(key: "tokenKey", value: newToken);
  }

  Future onReady(BuildContext context) async {
    prolongToken(context);
    String? img = await storage.read(key: "avatar");
    img != null ? file = File(img) : file;

    String? token = await storage.read(key: "tokenKey");
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");

    var dio = Dio();
    final responseProlongToken = await dio.post(Config.proLongToken, queryParameters: {"accessToken": token});
    token = responseProlongToken.data['accessToken'];
    await storage.write(key: "tokenKey", value: token);
    String? token2 = await storage.read(key: "tokenKey");
    final responseAuth = await dio.post(Config.apiHost, data: {"login": login, "password": password});

    var userData = responseAuth.data['userInfo'];
    userType = userData["userType"];

    userData["email"] != null ? email = userData["email"] : email = '';
    userData["phone"] != null ? phone = userData["phone"] : phone = '';
    String emailTemp = email;
    String phoneTemp = phone;
    emailController?.text = emailTemp;
    phoneController?.text = phoneTemp;
    notifyListeners();

    if (userType == EnumUserType.student) {
      firstName = userData["firstName"];
      lastName = userData["lastName"];
      middleName = userData["middleName"];
      final responseStudent = await dio.get(Config.studCardHost, queryParameters: {"accessToken": token2});

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
    } else if (userType == EnumUserType.employee) {
      final responseEmployee = await dio.get(Config.empCardHost, queryParameters: {"accessToken": token2});

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

    final now = DateTime.now();
    final newYearDate = DateTime(now.year, DateTime.january, 3).toString().split(' ');
    final currentDate = now.toString().split(' ');
    if (currentDate[0] == newYearDate[0]) {
      _showAlertDialog(context);
    }
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Main screen (profile) event');
  }

  void updateProfile() async {
    var dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    await dio.post(Config.updateEmail, queryParameters: {"accessToken": token}, data: {"email": emailController?.text});
    await dio.post(Config.updatePhone, queryParameters: {"accessToken": token}, data: {"phone": phoneController?.text});
    email = emailController!.text;
    phone = phoneController!.text;
    notifyListeners();
  }

  void exitButton(context) async {
    await storage.write(key: "tokenKey", value: "");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthView()));
    notifyListeners();
  }

  void infoButton(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoOUProView()));
    notifyListeners();
  }

  void debtsButton(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DebtsView()));
    notifyListeners();
  }

  void checklistButton(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListView()));
    notifyListeners();
  }

  _showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Спасибо"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("С новым годом!"),
      content: const Text(
          "Наша команда разработчиков желает вам крепкого здоровья, удачи, благополучия, добра, радости, любви, счастья, хорошего настроения, улыбок, ярких впечатлений. Пусть тепло и уют всегда наполняют ваш дом, пусть солнечный свет согревает в любую погоду, а желания исполняются при одной мысли о них."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
