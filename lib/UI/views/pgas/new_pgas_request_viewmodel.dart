import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'model/faculty.dart';
import 'model/semester_type.dart';

class NewPgasRequestViewModel extends BaseViewModel {
  NewPgasRequestViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<FacultyModel> facultiesList = [];
  List<SemesterTypeModel> semestersList = [];
  FacultyModel? chooseFaculty;
  SemesterTypeModel? chooseSemester;
  final studyYears = ["2021-2022"];
  final courses = [
    "1",
    "2",
    "3",
    "4",
    "5",
  ];
  TextEditingController surnameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  String? chosenYear;
  String? chosenCourse;
  TextEditingController courseController = TextEditingController();

  onReady() async {
    await fetchInstitutesList();
    await fetchSemesterTypeList();
    String? firstName = await storage.read(key: "firstName");
    String? lastName = await storage.read(key: "lastName");
    String? middleName = await storage.read(key: "middleName");
    String? phone = await storage.read(key: "phone");
    String? group = await storage.read(key: "group");

    firstNameController.text = firstName!;
    surnameController.text = lastName!;
    middleNameController.text = middleName!;
    phone != null ? phoneController.text = phone : phoneController.text = '';
    groupController.text = group!;
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('New pgas request event');
  }

  fetchInstitutesList() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};
    var response = await http.post(
        Uri.parse(
            "https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getFacultyList"),
        headers: header);
    facultiesList = parseFaculties(json.decode(response.body)["result"]);
    notifyListeners();
  }

  fetchSemesterTypeList() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};
    var response = await http.post(
        Uri.parse(
            "https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getSemesterTypeList"),
        headers: header);
    semestersList = parseSemesterTypes(json.decode(response.body)["result"]);
    notifyListeners();
  }

  List<FacultyModel> parseFaculties(List response) {
    return response
        .map<FacultyModel>((json) => FacultyModel.fromJson(json))
        .toList();
  }

  List<SemesterTypeModel> parseSemesterTypes(List response) {
    return response
        .map<SemesterTypeModel>((json) => SemesterTypeModel.fromJson(json))
        .toList();
  }

  sendButtonAction(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    if (surnameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        middleNameController.text.isNotEmpty &&
        groupController.text.isNotEmpty &&
        chosenYear!.isNotEmpty &&
        chosenCourse!.isNotEmpty &&
        chooseSemester != null &&
        chooseFaculty != null) {
      Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};

      Map<String, dynamic> body = {
        "surname": surnameController.text,
        "name": firstNameController.text,
        "patronymic": middleNameController.text,
        "phone": phoneController.text,
        "group": groupController.text,
        "studyYear": chosenYear,
        "courseNum": chosenCourse,
        "semesterTypeId": chooseSemester!.semesterTypeId.toString(),
        "facultyId": chooseFaculty!.id.toString()
      };

      var response = await http.post(
          Uri.parse(
              "https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/addRequest"),
          headers: header,
          body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ваша заявка успешно отправлена.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Ошибка при отправке заявки! Код ошибки: ${response.statusCode}")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Заполните все поля заявки!")));
    }
  }
}
