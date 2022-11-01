import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/schedule2.0_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';

class NewScheduleViewModel extends BaseViewModel {
  NewScheduleViewModel(BuildContext context);

  static const storage = FlutterSecureStorage();
  bool circle = true;
  bool tableView = false;
  int indexDay = DateTime.now().weekday;
  bool currentTable = false;
  bool weekType = true;
  int? groupId;
  int? groupIdChoice;
  int? currentSemester;
  int? currentWeek;
  FinalTable? scheduleTable;
  ScheduleRequest? scheduleSemester;
  FacultyList? scheduleFaculty;
  GroupList? scheduleGroup;
  List<WeekGetId> weekID = [];
  List<GroupList> groupList = [];
  List<FacultyList> facultyList = [];
  List<ScheduleRequest> scheduleList = [];
  List<String> coupleTime = [
    '8:00 - 9:35',
    '9:45 - 11:20',
    '11:45 - 13:20',
    '13:30 - 15:05',
    '15:30 - 17:05',
    '17:15 - 18:50',
    '19:00 - 20:35'
  ];

  Future onReady() async {
    getScheduleOnRequest();
    getSchedule();
  }

  void changeWeek(value) {
    weekType = value;
    notifyListeners();
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

  void choiceSchedule() async {
    currentTable = false;
    await getSchedule();
    notifyListeners();
  }

  tableViewOnOff(data) {
    tableView = data;
    notifyListeners();
  }

  getSchedule() async {
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();
    var semesterResponse = await dio.get(Config.semesterList);
    var response = await dio
        .get(Config.currentGroupList, queryParameters: {"accessToken": token});
    groupId = response.data['currentGroupList'][0]['groupId'];
    currentSemester = semesterResponse.data['result'][0]['Id'];
    var weekResponse =
        await dio.get('${Config.weekList}?semesterId=$currentSemester');
    currentWeek = weekResponse.data['result'][0]['Id'];
    currentTable == true
        ? groupId = groupIdChoice
        : groupId = response.data['currentGroupList'][0]['groupId'];
    var getScheduleTable = await http.get(Uri.parse(
        '${Config.scheduleTable}?groupId=$groupId&semesterWeekId=$currentWeek'));
    var mainTable = getScheduleTable.body;
    final jsonResponse = json.decode(mainTable)['result']['Table'];
    //final jsonResponseCoupleList =
    //  json.decode(mainTable)['result']['CoupleList'];
    scheduleTable = FinalTable.fromJson(jsonResponse);
    circle = false;
    tableView = true;
    notifyListeners();
  }

  getScheduleOnRequest() async {
    var response = await http.get(Uri.parse(Config.semesterList));
    scheduleList = parseSchedule(json.decode(response.body)['result']);
    var response3 = await http.get(
        Uri.parse('${Config.facultyList}?semesterId=${scheduleList[0].id}'));
    facultyList = parseFaculty(json.decode(response3.body)["result"]);
    currentTable = false;
    notifyListeners();
  }

  changeTable(value) {
    currentTable = value;
    tableView = false;

    if (currentTable == false) {
      scheduleFaculty = null;
      scheduleGroup = null;
      groupList = [];

      notifyListeners();
    }

    notifyListeners();
  }

  List<ScheduleRequest> parseSchedule(List response) {
    return response
        .map<ScheduleRequest>((json) => ScheduleRequest.fromJson(json))
        .toList();
  }

  List<FacultyList> parseFaculty(List response) {
    return response
        .map<FacultyList>((json) => FacultyList.fromJson(json))
        .toList();
  }

  void changeSemester(value) async {
    tableView = false;
    scheduleFaculty = null;
    scheduleGroup = null;
    scheduleSemester = value;
    notifyListeners();
    var response = await http.get(
        Uri.parse('${Config.facultyList}?semesterId=${scheduleList[0].id}'));
    facultyList = parseFaculty(json.decode(response.body)["result"]);
    notifyListeners();
  }

  void changeFaculty(value) async {
    tableViewOnOff(false);
    scheduleGroup = null;
    scheduleFaculty = value;
    notifyListeners();
    var response = await http.get(Uri.parse(
        '${Config.groupList}?facultyId=${scheduleFaculty!.id}&semesterId=${scheduleList[0].id}'));
    groupList = parseGroup(json.decode(response.body)["result"]);
    notifyListeners();
  }

  void changeGroup(value) async {
    scheduleGroup = value;
    tableViewOnOff(false);
    notifyListeners();
    var response = await http
        .get(Uri.parse('${Config.weekList}?semesterId=${scheduleList[0].id}'));
    weekID = parseWeekID(json.decode(response.body)["result"]);
    groupIdChoice = scheduleGroup!.id;
    notifyListeners();
  }

  List<GroupList> parseGroup(List response) {
    return response.map<GroupList>((json) => GroupList.fromJson(json)).toList();
  }

  List<WeekGetId> parseWeekID(List response) {
    return response.map<WeekGetId>((json) => WeekGetId.fromJson(json)).toList();
  }
}
