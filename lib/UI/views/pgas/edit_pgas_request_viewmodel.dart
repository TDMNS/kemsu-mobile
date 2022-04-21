import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'model/faculty.dart';
import 'model/pgas_detail.dart';
import 'model/semester_type.dart';
import 'pgas_request_info_screen.dart';

class EditPgasRequestViewModel extends BaseViewModel {
  EditPgasRequestViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  PgasDetailModel? detailPgasRequest;
  List<FacultyModel> facultiesList = [];
  List<SemesterTypeModel> semestersList = [];
  FacultyModel? chooseFaculty;
  SemesterTypeModel? chooseSemester;
  final studyYears = ["2021-2022"];
  final courses = ["1", "2", "3", "4", "5",];
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
    notifyListeners();
  }

  fetchDetailPgasRequest() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    Map<String, dynamic> body = {
      "requestId": pgasRequestId
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getRequestInfo"), headers: header, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      detailPgasRequest = PgasDetailModel.fromJson(json.decode(response.body)["result"]);
      notifyListeners();
      surnameController.text = detailPgasRequest!.surname!;
      firstNameController.text = detailPgasRequest!.name!;
      middleNameController.text = detailPgasRequest!.patronymic!;
      phoneController.text = detailPgasRequest!.phone!;
      groupController.text = detailPgasRequest!.group!;
      chosenYear = detailPgasRequest!.studyYear;
      chosenCourse = detailPgasRequest!.courseNum.toString();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  fetchInstitutesList() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getFacultyList"), headers: header);
    facultiesList = parseFaculties(json.decode(response.body)["result"]);
    chooseFaculty = facultiesList.where((element) => element.id == detailPgasRequest!.facultyId).single;
    notifyListeners();
  }

  fetchSemesterTypeList() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getSemesterTypeList"), headers: header);
    semestersList = parseSemesterTypes(json.decode(response.body)["result"]);
    chooseSemester = semestersList.where((element) => element.semesterTypeId == detailPgasRequest!.semesterTypeId).single;
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
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    if (surnameController.text.isNotEmpty && firstNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty && middleNameController.text.isNotEmpty && groupController.text.isNotEmpty &&
        chosenYear!.isNotEmpty && chosenCourse!.isNotEmpty && chooseSemester != null && chooseFaculty != null) {
      Map<String, String> header = {
        "X-Access-Token": "$eiosAccessToken"
      };

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

      var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/editRequest"), headers: header, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Данные успешно сохранены.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка при сохранении данных! Код ошибки: ${response.statusCode}")));
        print(response.body);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Заполните все поля!")));
    }
  }
}