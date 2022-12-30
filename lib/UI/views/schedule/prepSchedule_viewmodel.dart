import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_model.dart';
import 'package:http/http.dart' as http;
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';
import 'package:html/parser.dart' as parser;

import '../../../API/config.dart';

class PrepScheduleViewModel extends BaseViewModel {
  PrepScheduleViewModel(BuildContext context);
  bool circle = true;
  bool table = false;
  int selectedIndex = 1;
  int indexDay = DateTime.now().weekday;
  PrepScheduleTable? prepScheduleTable;
  List<PrepScheduleTable>? scheduleList = [];
  int? teacherId;
  int? currentTeacherID;
  String? teacherFIO;
  String? currentDate;
  String? currentWeek;
  int weekId = 0;
  bool tableView = false;
  bool currentTable = false;
  bool weekType = true;
  int? groupId;
  int? groupIdChoice;
  int? currentSemester;
  ScheduleRequest? scheduleSemester;
  FacultyList? scheduleFaculty;
  GroupList? scheduleGroup;
  List<WeekGetId> weekID = [];
  List<GroupList> groupList = [];
  List<FacultyList> facultyList = [];
  List<String> coupleTime = [
    '8:00 - 9:35',
    '9:45 - 11:20',
    '11:45 - 13:20',
    '13:30 - 15:05',
    '15:30 - 17:05',
    '17:15 - 18:50',
    '19:00 - 20:35'
  ];

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

  void changeWeek(value) {
    weekId = value;
    notifyListeners();
  }

  changeTeacher(data) async {
    //choiceTeacher = value;
    var dio = Dio();
    teacherFIO = data;
    teacherId = 0;
    //print('Data FIO: ${teacherList[0].prepId}');
    for (int i = 0; i < teacherList.length; i++) {
      if (teacherFIO == teacherList[i].fio) {
        teacherId = teacherList[i].prepId;
      }
    }
    circle = true;
    print('WTF: $teacherId');
    String? token = await storage.read(key: "tokenKey");
    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response = await http.get(Uri.parse(
        '${Config.prepSchedule}?semesterId=9&prepId=$teacherId&accessToken=$token'));

    var jsonResponse = json.decode(response.body)['result'];

    result = Result.fromJson(jsonResponse);

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
  }

  getTeacher() async {
    String? token = await storage.read(key: "tokenKey");
    String? fio = await storage.read(key: "FIO");
    int? type;
    String? userTypeTemp = await storage.read(key: "userType");
    userTypeTemp == 'обучающийся' ? type = 0 : type = 1;

    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);

    var response = await http.get(
        Uri.parse('${Config.teacherList}?accessToken=$token&semesterId=9'));
    teacherList = parseTeacherList(json.decode(response.body)['teacherList']);
    for (int i = 0; i < teacherList.length; i++) {
      if (teacherList[i].fio == fio) {
        teacherFIO = teacherList[i].fio;
        currentTeacherID = teacherList[i].prepId;
        print("Old ID is: ${teacherList[i].prepId}");
        print("New ID is: $currentTeacherID");
      }
    }
    print('FIO: $fio');
    print('AAAA: ${response.body}');
    type == 0 ? changeTeacher(teacherFIO) : changeTeacher(fio);

    circle = false;
    notifyListeners();
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

class Teacher {
  final String fio;
  final int prepId;

  const Teacher({required this.fio, required this.prepId});

  static Teacher fromJson(Map<String, dynamic> json) =>
      Teacher(fio: json['fio'], prepId: json['prepId']);
}

class TeacherApi {
  static Future<List<Teacher>> getTeacherData(String querry) async {
    List<CurrentGroupList> currentGroupList = [];

    final storage = const FlutterSecureStorage();
    List<CurrentGroupList> parseCurrentGroupList(List response) {
      return response
          .map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json))
          .toList();
    }

    String? token = await storage.read(key: "tokenKey");
    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);

    var response = await http.get(Uri.parse(
        '${Config.teacherList}?accessToken=$token&semesterId=${currentGroupList[0].semesterId}'));
    if (response.statusCode == 200) {
      final List teachers = json.decode(response.body)['teacherList'];

      return teachers.map((json) => Teacher.fromJson(json)).where((teacher) {
        final fioLower = teacher.fio.toLowerCase();
        final querryLower = querry.toLowerCase();

        return fioLower.contains(querryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
