import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import '../../../API/config.dart';
import '../auth/auth_view.dart';
import '../iais/iais_view.dart';
import '../debts/debts_view.dart';
import '../checkList/check_list_view.dart';
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
  String debtData = '';
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

    print('NewFile22: $file');
    notifyListeners();
  }

  changeTheme(value) {
    darkTheme = value;
    print('Value is: $value');
    notifyListeners();
  }

  getThemeToMain() {
    notifyListeners();
    return darkTheme;
  }

  prolongToken(context) async {
    // var dio = Dio();
    //
    String? token = await storage.read(key: 'tokenKey');
    // final responseProlongToken = await dio
    //     .post(Config.proLongToken, queryParameters: {"accessToken": token});
    // var newToken = responseProlongToken.data['accessToken'];
    // await storage.write(key: "tokenKey", value: newToken);
    // Map data = {"accessToken": token};
    //var body = json.encode(data);
    final responseToken = await http
        .post(Uri.parse(Config.proLongToken), body: {"accessToken": token});
    responseToken.statusCode == 401
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AuthView()))
        : null;
    print(responseToken.statusCode);
    var newToken = json.decode(responseToken.body)['accessToken'];
    await storage.write(key: "tokenKey", value: newToken);
  }

  Future onReady(BuildContext context) async {
    prolongToken(context);
    String? img = await storage.read(key: "avatar");
    img != null ? file = File(img) : file;

    print('NewFile22: $file');
    String? token = await storage.read(key: "tokenKey");
    print('Old token:' + token!);
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");
    String? userTypeTemp = await storage.read(key: "userType");
    var dio = Dio();
    final responseProlongToken = await dio
        .post(Config.proLongToken, queryParameters: {"accessToken": token});
    token = responseProlongToken.data['accessToken'];
    print('Code: ${responseProlongToken.statusCode}');
    await storage.write(key: "tokenKey", value: token);
    String? token2 = await storage.read(key: "tokenKey");
    print('New token: ' + token2!);
    final responseAuth = await dio
        .post(Config.apiHost, data: {"login": login, "password": password});
    print('Code: ${responseAuth.statusCode}');
    print('Reponse: ${responseAuth.data}');

    var userData = responseAuth.data['userInfo'];
    userType = userData["userType"];

    userData["email"] != null ? email = userData["email"] : email = '';
    userData["phone"] != null ? phone = userData["phone"] : phone = '';
    String emailTemp = email;
    String phoneTemp = phone;
    emailController?.text = emailTemp;
    phoneController?.text = phoneTemp;
    notifyListeners();

    print(userData);
    if (userType == EnumUserType.student) {
      firstName = userData["firstName"];
      lastName = userData["lastName"];
      middleName = userData["middleName"];
      final responseStudent = await dio
          .get(Config.studCardHost, queryParameters: {"accessToken": token2});

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
          .get(Config.studMoneyDebt, queryParameters: {"accessToken": token2});
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
          .get(Config.empCardHost, queryParameters: {"accessToken": token2});

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
    final newYearDate =
        DateTime(now.year, DateTime.january, 3).toString().split(' ');
    final currentDate = now.toString().split(' ');
    if (currentDate[0] == newYearDate[0]) {
      _showAlertDialog(context);
    }
    notifyListeners();
  }

  void old_saveImage(image) async {
    // await storage.write(key: "avatar", value: '$image');
    //avatar = await storage.read(key: 'avatar');
    //final File newImage = await image.copy('images/avatar.png');
    //image = avatar;
    //print('Image: $image, Save Image: $avatar');
    Uint8List imageBytes = await image!.readAsBytes();
    String _base64String = base64.encode(imageBytes);
    print(_base64String);
    await storage.write(key: "avatar", value: _base64String);
    //print(img64);
    notifyListeners();
  }

  void updateProfile() async {
    var dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    final updateEmail = await dio.post(Config.updateEmail,
        queryParameters: {"accessToken": token},
        data: {"email": emailController?.text});
    final phoneEmail = await dio.post(Config.updatePhone,
        queryParameters: {"accessToken": token},
        data: {"phone": phoneController?.text});
    email = emailController!.text;
    phone = phoneController!.text;
    notifyListeners();
    print(updateEmail.data);
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

  _showAlertDialog(BuildContext context) {
    // set up the button
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

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
