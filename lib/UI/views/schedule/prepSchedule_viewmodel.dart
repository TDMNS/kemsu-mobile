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
  bool table = false;
  int selectedIndex = 1;
  int indexDay = DateTime.now().weekday;
  PrepScheduleTable? prepScheduleTable;
  List<PrepScheduleTable>? scheduleList = [];

  List<CurrentGroupList> currentGroupList = [];

  List<TeacherList> teacherList = [];
  List<Even> evenList = [];

  TeacherList? choiceTeacher;
  Result? result;
  PrepScheduleApi? all;

  final storage = const FlutterSecureStorage();

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    getTeacher();
  }

  changeTeacher(value) async {
    choiceTeacher = value;
    notifyListeners();
    String? token = await storage.read(key: "tokenKey");
    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response = await http.get(Uri.parse(
        '${Config.prepSchedule}?semesterId=${currentGroupList[0].semesterId}&prepId=${choiceTeacher!.prepId}&accessToken=$token'));
    var jsonResponse = json.decode(response.body)['result'];
    result = Result.fromJson(jsonResponse);

    int days = result!.prepScheduleTable!.length;
    int ceilLength = result!.prepScheduleTable![0].ceilList!.length;

    //evenList = parseEvenList(
    //    jsonResponse['prepScheduleTable'][0]['ceilList'][4]['ceil']['even']);
    evenList = parseEvenList(
        jsonResponse['prepScheduleTable'][0]['ceilList'][4]['ceil']['even']);
    for (int i = 0; i < evenList.length; i++) {
      print(evenList[i].discName);
    }

    circle = false;

    notifyListeners();
  }

  List<CurrentGroupList> parseCurrentGroupList(List response) {
    return response
        .map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json))
        .toList();
  }

  void choiceDay(action) {
    if (action == 'next') {
      indexDay++;
      indexDay == 8 ? indexDay = 1 : indexDay == 1;
    } else if (action == 'back') {
      indexDay--;
      indexDay == 0 ? indexDay = 7 : indexDay == 7;
    }
    notifyListeners();
    print(indexDay);
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

  List<Even> parseEvenList(List response) {
    return response.map<Even>((json) => Even.fromJson(json)).toList();
  }
}
