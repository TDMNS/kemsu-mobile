import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../../Configurations/config.dart';
import '../common_models/faculty_model.dart';
import '../common_models/semester_type_model.dart';
import '../common_models/pgas_detail_model.dart';

class EditPgasRequestViewModel extends BaseViewModel {
  EditPgasRequestViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PgasDetailModel? detailPgasRequest;
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
  String? facultyFromApi;
  String? semesterFromApi;
  bool circle = true;
  bool isChanged = false;

  Future onReady() async {
    await fetchDetailPgasRequest();
    await fetchInstitutesList();
    await fetchSemesterTypeList();
    circle = false;
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Edit pgas request event');
  }

  fetchDetailPgasRequest() async {
    String? accessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    Map<String, dynamic> body = {"requestId": pgasRequestId};
    var response = await http.post(
        Uri.parse(Config.pgasGetRequestInfo),
        headers: header,
        body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      detailPgasRequest =
          PgasDetailModel.fromJson(json.decode(response.body)["result"]);
      notifyListeners();
      surnameController.text = detailPgasRequest!.surname!;
      firstNameController.text = detailPgasRequest!.name!;
      middleNameController.text = detailPgasRequest!.patronymic!;
      phoneController.text = detailPgasRequest!.phone!;
      groupController.text = detailPgasRequest!.group!;
      chosenYear = detailPgasRequest!.studyYear;
      chosenCourse = detailPgasRequest!.courseNum.toString();
      notifyListeners();
    } else {}
  }

  fetchInstitutesList() async {
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    var response = await http.post(
        Uri.parse(Config.pgasGetFacultyList),
        headers: header);
    facultiesList = parseFaculties(json.decode(response.body)["result"]);
    chooseFaculty = facultiesList
        .where((element) => element.id == detailPgasRequest!.facultyId)
        .single;
    notifyListeners();
  }

  fetchSemesterTypeList() async {
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    var response = await http.post(
        Uri.parse(Config.pgasGetSemesterTypeList),
        headers: header);
    semestersList = parseSemesterTypes(json.decode(response.body)["result"]);
    chooseSemester = semestersList
        .where((element) =>
            element.semesterTypeId == detailPgasRequest!.semesterTypeId)
        .single;
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

  saveButtonAction(context) async {
    String? accessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    if (surnameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        middleNameController.text.isNotEmpty &&
        groupController.text.isNotEmpty &&
        chosenYear!.isNotEmpty &&
        chosenCourse!.isNotEmpty &&
        chooseSemester != null &&
        chooseFaculty != null) {
      Map<String, String> header = {"X-Access-Token": "$accessToken"};

      Map<String, dynamic> body = {
        "surname": surnameController.text,
        "name": firstNameController.text,
        "patronymic": middleNameController.text,
        "phone": phoneController.text,
        "group": groupController.text,
        "studyYear": chosenYear,
        "courseNum": chosenCourse,
        "semesterTypeId": chooseSemester!.semesterTypeId.toString(),
        "facultyId": chooseFaculty!.id.toString(),
        "requestId": pgasRequestId
      };

      var response = await http.post(
          Uri.parse(Config.pgasEditRequest),
          headers: header,
          body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Данные успешно сохранены.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Ошибка при сохранении данных! Код ошибки: ${response.statusCode}")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Заполните все поля!")));
    }
  }
}
