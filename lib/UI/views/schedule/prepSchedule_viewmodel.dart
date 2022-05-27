import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_model.dart';
import 'package:http/http.dart' as http;
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';

import '../../../API/config.dart';

class PrepScheduleViewModel extends BaseViewModel {
  PrepScheduleViewModel(BuildContext context);
  bool circle = true;
  int selectedIndex = 1;
  List<CurrentGroupList> currentGroupList = [];
  List<TeacherList> teacherList = [];
  List<PrepScheduleModel> prepSchedule = [];
  TeacherList? choiceTeacher;

  final storage = const FlutterSecureStorage();

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    getTeacher();
  }

  void changeTeacher(value) async {
    choiceTeacher = value;
    notifyListeners();
    String? token = await storage.read(key: "tokenKey");
    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response = await http.get(Uri.parse(
        '${Config.prepSchedule}?semesterId=${currentGroupList[0].semesterId}&prepId=$choiceTeacher?accessToken=$token'));
    prepSchedule = parsePrepScheduleModel(json.decode(response.body)['result']);
    print(prepSchedule[0]);
    notifyListeners();
  }

  List<CurrentGroupList> parseCurrentGroupList(List response) {
    return response
        .map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json))
        .toList();
  }

  void getTeacher() async {
    String? token = await storage.read(key: "tokenKey");
    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);

    var response = await http.get(Uri.parse(
        '${Config.teacherList}?accessToken=$token&semesterId=${currentGroupList[0].semesterId}'));
    teacherList = parseTeacherList(json.decode(response.body)['teacherList']);
    notifyListeners();
    print(teacherList[0].fio);
  }

  List<TeacherList> parseTeacherList(List response) {
    return response
        .map<TeacherList>((json) => TeacherList.fromJson(json))
        .toList();
  }

  List<PrepScheduleModel> parsePrepScheduleModel(List response) {
    return response
        .map<PrepScheduleModel>((json) => PrepScheduleModel.fromJson(json))
        .toList();
  }
}
