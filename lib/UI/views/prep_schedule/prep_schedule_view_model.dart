import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/profile/profile_view_model.dart';
import 'package:kemsu_app/UI/views/prep_schedule/prep_schedule_model.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

import '../../../Configurations/config.dart';
import '../../splash_screen.dart';
import '../../common_widgets.dart';

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
  int? weekNumApi;
  String? weekTypeApi;
  String? currentDateApi;
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

  String? appBarTitle;

  final storage = const FlutterSecureStorage();

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    getAppBarTitle();
    getTeacher();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Teacher schedule event');
  }

  void changeWeek(value) {
    weekType = value;
    notifyListeners();
  }

  changeTeacher(data) async {
    teacherFIO = data;
    teacherId = 0;
    for (int i = 0; i < teacherList.length; i++) {
      if (teacherFIO == teacherList[i].fio) {
        teacherId = teacherList[i].prepId;
      }
    }
    circle = true;
    String? token = await storage.read(key: "tokenKey");
    var response2 = await http.get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList = parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response =
        await http.get(Uri.parse('${Config.prepSchedule}?semesterId=11&prepId=$teacherId&accessToken=$token'));

    var jsonResponse = json.decode(response.body)['result'];

    result = Result.fromJson(jsonResponse);

    circle = false;

    notifyListeners();
  }

  List<CurrentGroupList> parseCurrentGroupList(List response) {
    return response.map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json)).toList();
  }

  void choiceDay(action) {
    if (action == 'next') {
      indexDay++;
      indexDay == 7 ? indexDay = 1 : indexDay == 1;
    } else if (action == 'back') {
      indexDay--;
      indexDay == 0 ? indexDay = 6 : indexDay == 6;
    }
    print(indexDay);
    notifyListeners();
  }

  getAppBarTitle() async {
    String? userType = await storage.read(key: "userType");
    if (userType == EnumUserType.employee) {
      appBarTitle = EnumScreensWithoutPopArrow.prepScheduleEmp;
    } else {
      appBarTitle = EnumScreensWithoutPopArrow.prepScheduleStud;
    }
  }

  getTeacher() async {
    var dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    String? fio = await storage.read(key: "FIO");
    int? type;
    String? userTypeTemp = await storage.read(key: "userType");
    userTypeTemp == 'обучающийся' ? type = 0 : type = 1;
    var getWeek = await dio.get(Config.getWeekNum, options: Options(headers: {'x-access-token': token}));
    weekNumApi = getWeek.data['currentDay']['weekNum'];
    weekTypeApi = getWeek.data['currentDay']['weekType'];
    currentDateApi = getWeek.data['currentDay']['currentDate'];
    weekTypeApi == 'четная' ? weekType = true : weekType = false;
    var response2 = await http.get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList = parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);

    var response = await http.get(Uri.parse('${Config.teacherList}?accessToken=$token&semesterId=11'));
    teacherList = parseTeacherList(json.decode(response.body)['teacherList']);
    for (int i = 0; i < teacherList.length; i++) {
      if (teacherList[i].fio == fio) {
        teacherFIO = teacherList[i].fio;
        currentTeacherID = teacherList[i].prepId;
      }
    }
    type == 0 ? changeTeacher(teacherFIO) : changeTeacher(fio);

    notifyListeners();
  }

  List<TeacherList> parseTeacherList(List response) {
    return response.map<TeacherList>((json) => TeacherList.fromJson(json)).toList();
  }

  List<Even> parseEvenList(List response) {
    return response.map<Even>((json) => Even.fromJson(json)).toList();
  }
}

class Teacher {
  final String fio;
  final int prepId;

  const Teacher({required this.fio, required this.prepId});

  static Teacher fromJson(Map<String, dynamic> json) => Teacher(fio: json['fio'], prepId: json['prepId']);
}

class TeacherApi {
  static Future<List<Teacher>> getTeacherData(String querry) async {
    List<CurrentGroupList> currentGroupList = [];

    List<CurrentGroupList> parseCurrentGroupList(List response) {
      return response.map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json)).toList();
    }

    String? token = await storage.read(key: "tokenKey");
    var response2 = await http.get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList = parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);

    var response = await http
        .get(Uri.parse('${Config.teacherList}?accessToken=$token&semesterId=${currentGroupList[0].semesterId}'));
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
