import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../../../API/config.dart';

class ScheduleViewModel extends BaseViewModel {
  ScheduleViewModel(BuildContext context);

  var dio = Dio();
  List<ScheduleRequest> scheduleList = [];
  List<FacultyList> facultyList = [];
  List<GroupList> groupList = [];
  List<WeekList> weekList = [];
  List<WeekGetId> weekID = [];
  List<WeekType> weekType = [];
  List<CoupleList> coupleList = [];
  List<CoupleModel> coupleModel = [];
  List<CurrentGroupList> currentGroupList = [];
  List<DropdownMenuItem<String>> dropdownItems = [];
  bool table = false;
  int indexDay = DateTime.now().weekday;
  bool currentTable = true;
  String? currentDate;
  String? currentWeek;
  int? weekId;

  List<CoupleModel> modelDay1All1 = [];
  List<CoupleModel> modelDay1All2 = [];
  List<CoupleModel> modelDay1All3 = [];
  List<CoupleModel> modelDay1All4 = [];
  List<CoupleModel> modelDay1All5 = [];
  List<CoupleModel> modelDay1All6 = [];
  List<CoupleModel> modelDay1All7 = [];
  List<CoupleModel> modelDay1Even1 = [];
  List<CoupleModel> modelDay1Even2 = [];
  List<CoupleModel> modelDay1Even3 = [];
  List<CoupleModel> modelDay1Even4 = [];
  List<CoupleModel> modelDay1Even5 = [];
  List<CoupleModel> modelDay1Even6 = [];
  List<CoupleModel> modelDay1Even7 = [];
  List<CoupleModel> modelDay1Odd1 = [];
  List<CoupleModel> modelDay1Odd2 = [];
  List<CoupleModel> modelDay1Odd3 = [];
  List<CoupleModel> modelDay1Odd4 = [];
  List<CoupleModel> modelDay1Odd5 = [];
  List<CoupleModel> modelDay1Odd6 = [];
  List<CoupleModel> modelDay1Odd7 = [];

  List<CoupleModel> modelDay2All1 = [];
  List<CoupleModel> modelDay2All2 = [];
  List<CoupleModel> modelDay2All3 = [];
  List<CoupleModel> modelDay2All4 = [];
  List<CoupleModel> modelDay2All5 = [];
  List<CoupleModel> modelDay2All6 = [];
  List<CoupleModel> modelDay2All7 = [];
  List<CoupleModel> modelDay2Even1 = [];
  List<CoupleModel> modelDay2Even2 = [];
  List<CoupleModel> modelDay2Even3 = [];
  List<CoupleModel> modelDay2Even4 = [];
  List<CoupleModel> modelDay2Even5 = [];
  List<CoupleModel> modelDay2Even6 = [];
  List<CoupleModel> modelDay2Even7 = [];
  List<CoupleModel> modelDay2Odd1 = [];
  List<CoupleModel> modelDay2Odd2 = [];
  List<CoupleModel> modelDay2Odd3 = [];
  List<CoupleModel> modelDay2Odd4 = [];
  List<CoupleModel> modelDay2Odd5 = [];
  List<CoupleModel> modelDay2Odd6 = [];
  List<CoupleModel> modelDay2Odd7 = [];

  List<CoupleModel> modelDay3All1 = [];
  List<CoupleModel> modelDay3All2 = [];
  List<CoupleModel> modelDay3All3 = [];
  List<CoupleModel> modelDay3All4 = [];
  List<CoupleModel> modelDay3All5 = [];
  List<CoupleModel> modelDay3All6 = [];
  List<CoupleModel> modelDay3All7 = [];
  List<CoupleModel> modelDay3Even1 = [];
  List<CoupleModel> modelDay3Even2 = [];
  List<CoupleModel> modelDay3Even3 = [];
  List<CoupleModel> modelDay3Even4 = [];
  List<CoupleModel> modelDay3Even5 = [];
  List<CoupleModel> modelDay3Even6 = [];
  List<CoupleModel> modelDay3Even7 = [];
  List<CoupleModel> modelDay3Odd1 = [];
  List<CoupleModel> modelDay3Odd2 = [];
  List<CoupleModel> modelDay3Odd3 = [];
  List<CoupleModel> modelDay3Odd4 = [];
  List<CoupleModel> modelDay3Odd5 = [];
  List<CoupleModel> modelDay3Odd6 = [];
  List<CoupleModel> modelDay3Odd7 = [];

  List<CoupleModel> modelDay4All1 = [];
  List<CoupleModel> modelDay4All2 = [];
  List<CoupleModel> modelDay4All3 = [];
  List<CoupleModel> modelDay4All4 = [];
  List<CoupleModel> modelDay4All5 = [];
  List<CoupleModel> modelDay4All6 = [];
  List<CoupleModel> modelDay4All7 = [];
  List<CoupleModel> modelDay4Even1 = [];
  List<CoupleModel> modelDay4Even2 = [];
  List<CoupleModel> modelDay4Even3 = [];
  List<CoupleModel> modelDay4Even4 = [];
  List<CoupleModel> modelDay4Even5 = [];
  List<CoupleModel> modelDay4Even6 = [];
  List<CoupleModel> modelDay4Even7 = [];
  List<CoupleModel> modelDay4Odd1 = [];
  List<CoupleModel> modelDay4Odd2 = [];
  List<CoupleModel> modelDay4Odd3 = [];
  List<CoupleModel> modelDay4Odd4 = [];
  List<CoupleModel> modelDay4Odd5 = [];
  List<CoupleModel> modelDay4Odd6 = [];
  List<CoupleModel> modelDay4Odd7 = [];

  List<CoupleModel> modelDay5All1 = [];
  List<CoupleModel> modelDay5All2 = [];
  List<CoupleModel> modelDay5All3 = [];
  List<CoupleModel> modelDay5All4 = [];
  List<CoupleModel> modelDay5All5 = [];
  List<CoupleModel> modelDay5All6 = [];
  List<CoupleModel> modelDay5All7 = [];
  List<CoupleModel> modelDay5Even1 = [];
  List<CoupleModel> modelDay5Even2 = [];
  List<CoupleModel> modelDay5Even3 = [];
  List<CoupleModel> modelDay5Even4 = [];
  List<CoupleModel> modelDay5Even5 = [];
  List<CoupleModel> modelDay5Even6 = [];
  List<CoupleModel> modelDay5Even7 = [];
  List<CoupleModel> modelDay5Odd1 = [];
  List<CoupleModel> modelDay5Odd2 = [];
  List<CoupleModel> modelDay5Odd3 = [];
  List<CoupleModel> modelDay5Odd4 = [];
  List<CoupleModel> modelDay5Odd5 = [];
  List<CoupleModel> modelDay5Odd6 = [];
  List<CoupleModel> modelDay5Odd7 = [];

  List<CoupleModel> modelDay6All1 = [];
  List<CoupleModel> modelDay6All2 = [];
  List<CoupleModel> modelDay6All3 = [];
  List<CoupleModel> modelDay6All4 = [];
  List<CoupleModel> modelDay6All5 = [];
  List<CoupleModel> modelDay6All6 = [];
  List<CoupleModel> modelDay6All7 = [];
  List<CoupleModel> modelDay6Even1 = [];
  List<CoupleModel> modelDay6Even2 = [];
  List<CoupleModel> modelDay6Even3 = [];
  List<CoupleModel> modelDay6Even4 = [];
  List<CoupleModel> modelDay6Even5 = [];
  List<CoupleModel> modelDay6Even6 = [];
  List<CoupleModel> modelDay6Even7 = [];
  List<CoupleModel> modelDay6Odd1 = [];
  List<CoupleModel> modelDay6Odd2 = [];
  List<CoupleModel> modelDay6Odd3 = [];
  List<CoupleModel> modelDay6Odd4 = [];
  List<CoupleModel> modelDay6Odd5 = [];
  List<CoupleModel> modelDay6Odd6 = [];
  List<CoupleModel> modelDay6Odd7 = [];

  List<List<CoupleModel>> day1All = [];
  List<List<CoupleModel>> day1Even = [];
  List<List<CoupleModel>> day1Odd = [];

  List<List<CoupleModel>> day2All = [];
  List<List<CoupleModel>> day2Even = [];
  List<List<CoupleModel>> day2Odd = [];

  List<List<CoupleModel>> day3All = [];
  List<List<CoupleModel>> day3Even = [];
  List<List<CoupleModel>> day3Odd = [];

  List<List<CoupleModel>> day4All = [];
  List<List<CoupleModel>> day4Even = [];
  List<List<CoupleModel>> day4Odd = [];

  List<List<CoupleModel>> day5All = [];
  List<List<CoupleModel>> day5Even = [];
  List<List<CoupleModel>> day5Odd = [];

  List<List<CoupleModel>> day6All = [];
  List<List<CoupleModel>> day6Even = [];
  List<List<CoupleModel>> day6Odd = [];

  final storage = const FlutterSecureStorage();

  void changeWeek(value) {
    weekId = value;
    notifyListeners();
  }

  bool circle = true;

  Future onReady() async {
    getScheduleTable();
    getWeekData();
  }

  ScheduleRequest? scheduleSemester;
  FacultyList? scheduleFaculty;
  GroupList? scheduleGroup;

  int selectedIndex = 2;

  getSchedule() async {
    var response = await http.get(Uri.parse(Config.semesterList));
    scheduleList = parseSchedule(json.decode(response.body)['result']);
    print(scheduleList[0].title);
    circle = false;
    notifyListeners();

    var response3 = await http.get(
        Uri.parse('${Config.facultyList}?semesterId=${scheduleList[0].id}'));
    facultyList = parseFaculty(json.decode(response3.body)["result"]);
    //print(scheduleList[0].id);
    // print(currentGroupList[0].groupId);
    notifyListeners();
  }

  List<ScheduleRequest> parseSchedule(List response) {
    return response
        .map<ScheduleRequest>((json) => ScheduleRequest.fromJson(json))
        .toList();
  }

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<List<String>> getWeekData() async {
//Getting the response from the targeted url
    final response = await http.Client()
        .get(Uri.parse('https://kemsu.ru/education/schedule/'));
    //Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      //Getting the html document from the response
      var document = parser.parse(response.body);
      try {
        //Scraping the first article title
        var responseString1 =
            document.getElementsByClassName('calendar-week')[0].children[0];
        var responseString2 =
            document.getElementsByClassName('calendar-week')[0].children[1];

        currentDate = responseString1.text.trim();
        currentWeek = responseString2.text.trim();
        if (currentWeek!.substring(10, currentWeek!.length) == 'четная') {
          weekId = 1;
        } else {
          weekId = 0;
        }

        return [responseString1.text.trim(), responseString2.text.trim()];
      } catch (e) {
        return ['', '', 'Error!'];
      }
    } else {
      return ['', '', 'Error: ${response.statusCode}.'];
    }
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

  void changeSemester(value) async {
    table = false;
    scheduleFaculty = null;
    scheduleGroup = null;
    scheduleSemester = value;
    notifyListeners();
    var response = await http.get(
        Uri.parse('${Config.facultyList}?semesterId=${scheduleList[1].id}'));
    facultyList = parseFaculty(json.decode(response.body)["result"]);
    print(scheduleList[0].id);
    notifyListeners();
  }

  void changeFaculty(value) async {
    tableOff();
    scheduleGroup = null;
    scheduleFaculty = value;
    notifyListeners();
    var response = await http.get(Uri.parse(
        '${Config.groupList}?facultyId=${scheduleFaculty!.id}&semesterId=${scheduleList[1].id}'));
    groupList = parseGroup(json.decode(response.body)["result"]);
    notifyListeners();
  }

  void changeGroup(value) async {
    scheduleGroup = value;
    tableOff();
    notifyListeners();
    var response = await http
        .get(Uri.parse('${Config.weekList}?semesterId=${scheduleList[1].id}'));
    weekID = parseWeekID(json.decode(response.body)["result"]);
    print(weekID[0].id);
    notifyListeners();
  }

  List<CurrentGroupList> parseCurrentGroupList(List response) {
    return response
        .map<CurrentGroupList>((json) => CurrentGroupList.fromJson(json))
        .toList();
  }

  List<FacultyList> parseFaculty(List response) {
    return response
        .map<FacultyList>((json) => FacultyList.fromJson(json))
        .toList();
  }

  List<GroupList> parseGroup(List response) {
    return response.map<GroupList>((json) => GroupList.fromJson(json)).toList();
  }

  List<WeekGetId> parseWeekID(List response) {
    return response.map<WeekGetId>((json) => WeekGetId.fromJson(json)).toList();
  }

  List<WeekList> parseWeek(List response) {
    return response.map<WeekList>((json) => WeekList.fromJson(json)).toList();
  }

  List<CoupleModel> parseCouple(List response) {
    return response
        .map<CoupleModel>((json) => CoupleModel.fromJson(json))
        .toList();
  }

  List<CoupleList> parseCoupleList(List response) {
    return response
        .map<CoupleList>((json) => CoupleList.fromJson(json))
        .toList();
  }

  List<WeekType> parseWeekType(List response) {
    return response.map<WeekType>((json) => WeekType.fromJson(json)).toList();
  }

  tableOff() {
    table = false;
    notifyListeners();
  }

  tableOn() {
    table = true;
    notifyListeners();
  }

  getData() async {
    String? token = await storage.read(key: "tokenKey");

    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response = await http.get(Uri.parse(
        '${Config.weekList}?semesterId=${currentGroupList[0].semesterId}'));
    weekID = parseWeekID(json.decode(response.body)["result"]);
    //print(scheduleGroup!.id);
    notifyListeners();
  }

  getScheduleTable() async {
    http.Response response;
    String? token = await storage.read(key: "tokenKey");

    var response2 = await http
        .get(Uri.parse('${Config.currentGroupList}?accessToken=$token'));
    currentGroupList =
        parseCurrentGroupList(json.decode(response2.body)['currentGroupList']);
    var response3 = await http.get(Uri.parse(
        '${Config.weekList}?semesterId=${currentGroupList[0].semesterId}'));
    weekID = parseWeekID(json.decode(response3.body)["result"]);
    //print(scheduleGroup!.id);
    notifyListeners();
    print(currentGroupList[0].groupName);
    print(currentGroupList[0].groupId);

    currentTable == false
        ? response = await http.get(Uri.parse(
            '${Config.scheduleTable}?groupId=${scheduleGroup!.id}&semesterWeekId=${weekID[0].id}'))
        : response = await http.get(Uri.parse(
            '${Config.scheduleTable}?groupId=${currentGroupList[0].groupId}&semesterWeekId=${weekID[0].id}'));
    //day1 = parseDays(json.decode(response.body)['result']['Table']['weekDay1']);

    coupleList =
        parseCoupleList(json.decode(response.body)['result']['CoupleList']);

    Map<String, dynamic> map = json.decode(response.body)['result'];
    List<dynamic> day1All1 = map['Table']['weekDay1']['coupleAll1'];
    List<dynamic> day1All2 = map['Table']['weekDay1']['coupleAll2'];
    List<dynamic> day1All3 = map['Table']['weekDay1']['coupleAll3'];
    List<dynamic> day1All4 = map['Table']['weekDay1']['coupleAll4'];
    List<dynamic> day1All5 = map['Table']['weekDay1']['coupleAll5'];
    List<dynamic> day1All6 = map['Table']['weekDay1']['coupleAll6'];
    List<dynamic> day1All7 = map['Table']['weekDay1']['coupleAll7'];
    List<dynamic> day1Even1 = map['Table']['weekDay1']['coupleEven1'];
    List<dynamic> day1Even2 = map['Table']['weekDay1']['coupleEven2'];
    List<dynamic> day1Even3 = map['Table']['weekDay1']['coupleEven3'];
    List<dynamic> day1Even4 = map['Table']['weekDay1']['coupleEven4'];
    List<dynamic> day1Even5 = map['Table']['weekDay1']['coupleEven5'];
    List<dynamic> day1Even6 = map['Table']['weekDay1']['coupleEven6'];
    List<dynamic> day1Even7 = map['Table']['weekDay1']['coupleEven7'];
    List<dynamic> day1Odd1 = map['Table']['weekDay1']['coupleOdd1'];
    List<dynamic> day1Odd2 = map['Table']['weekDay1']['coupleOdd2'];
    List<dynamic> day1Odd3 = map['Table']['weekDay1']['coupleOdd3'];
    List<dynamic> day1Odd4 = map['Table']['weekDay1']['coupleOdd4'];
    List<dynamic> day1Odd5 = map['Table']['weekDay1']['coupleOdd5'];
    List<dynamic> day1Odd6 = map['Table']['weekDay1']['coupleOdd6'];
    List<dynamic> day1Odd7 = map['Table']['weekDay1']['coupleOdd7'];

    List<dynamic> day2All1 = map['Table']['weekDay2']['coupleAll1'];
    List<dynamic> day2All2 = map['Table']['weekDay2']['coupleAll2'];
    List<dynamic> day2All3 = map['Table']['weekDay2']['coupleAll3'];
    List<dynamic> day2All4 = map['Table']['weekDay2']['coupleAll4'];
    List<dynamic> day2All5 = map['Table']['weekDay2']['coupleAll5'];
    List<dynamic> day2All6 = map['Table']['weekDay2']['coupleAll6'];
    List<dynamic> day2All7 = map['Table']['weekDay2']['coupleAll7'];
    List<dynamic> day2Even1 = map['Table']['weekDay2']['coupleEven1'];
    List<dynamic> day2Even2 = map['Table']['weekDay2']['coupleEven2'];
    List<dynamic> day2Even3 = map['Table']['weekDay2']['coupleEven3'];
    List<dynamic> day2Even4 = map['Table']['weekDay2']['coupleEven4'];
    List<dynamic> day2Even5 = map['Table']['weekDay2']['coupleEven5'];
    List<dynamic> day2Even6 = map['Table']['weekDay2']['coupleEven6'];
    List<dynamic> day2Even7 = map['Table']['weekDay2']['coupleEven7'];
    List<dynamic> day2Odd1 = map['Table']['weekDay2']['coupleOdd1'];
    List<dynamic> day2Odd2 = map['Table']['weekDay2']['coupleOdd2'];
    List<dynamic> day2Odd3 = map['Table']['weekDay2']['coupleOdd3'];
    List<dynamic> day2Odd4 = map['Table']['weekDay2']['coupleOdd4'];
    List<dynamic> day2Odd5 = map['Table']['weekDay2']['coupleOdd5'];
    List<dynamic> day2Odd6 = map['Table']['weekDay2']['coupleOdd6'];
    List<dynamic> day2Odd7 = map['Table']['weekDay2']['coupleOdd7'];

    List<dynamic> day3All1 = map['Table']['weekDay3']['coupleAll1'];
    List<dynamic> day3All2 = map['Table']['weekDay3']['coupleAll2'];
    List<dynamic> day3All3 = map['Table']['weekDay3']['coupleAll3'];
    List<dynamic> day3All4 = map['Table']['weekDay3']['coupleAll4'];
    List<dynamic> day3All5 = map['Table']['weekDay3']['coupleAll5'];
    List<dynamic> day3All6 = map['Table']['weekDay3']['coupleAll6'];
    List<dynamic> day3All7 = map['Table']['weekDay3']['coupleAll7'];
    List<dynamic> day3Even1 = map['Table']['weekDay3']['coupleEven1'];
    List<dynamic> day3Even2 = map['Table']['weekDay3']['coupleEven2'];
    List<dynamic> day3Even3 = map['Table']['weekDay3']['coupleEven3'];
    List<dynamic> day3Even4 = map['Table']['weekDay3']['coupleEven4'];
    List<dynamic> day3Even5 = map['Table']['weekDay3']['coupleEven5'];
    List<dynamic> day3Even6 = map['Table']['weekDay3']['coupleEven6'];
    List<dynamic> day3Even7 = map['Table']['weekDay3']['coupleEven7'];
    List<dynamic> day3Odd1 = map['Table']['weekDay3']['coupleOdd1'];
    List<dynamic> day3Odd2 = map['Table']['weekDay3']['coupleOdd2'];
    List<dynamic> day3Odd3 = map['Table']['weekDay3']['coupleOdd3'];
    List<dynamic> day3Odd4 = map['Table']['weekDay3']['coupleOdd4'];
    List<dynamic> day3Odd5 = map['Table']['weekDay3']['coupleOdd5'];
    List<dynamic> day3Odd6 = map['Table']['weekDay3']['coupleOdd6'];
    List<dynamic> day3Odd7 = map['Table']['weekDay3']['coupleOdd7'];

    List<dynamic> day4All1 = map['Table']['weekDay4']['coupleAll1'];
    List<dynamic> day4All2 = map['Table']['weekDay4']['coupleAll2'];
    List<dynamic> day4All3 = map['Table']['weekDay4']['coupleAll3'];
    List<dynamic> day4All4 = map['Table']['weekDay4']['coupleAll4'];
    List<dynamic> day4All5 = map['Table']['weekDay4']['coupleAll5'];
    List<dynamic> day4All6 = map['Table']['weekDay4']['coupleAll6'];
    List<dynamic> day4All7 = map['Table']['weekDay4']['coupleAll7'];
    List<dynamic> day4Even1 = map['Table']['weekDay4']['coupleEven1'];
    List<dynamic> day4Even2 = map['Table']['weekDay4']['coupleEven2'];
    List<dynamic> day4Even3 = map['Table']['weekDay4']['coupleEven3'];
    List<dynamic> day4Even4 = map['Table']['weekDay4']['coupleEven4'];
    List<dynamic> day4Even5 = map['Table']['weekDay4']['coupleEven5'];
    List<dynamic> day4Even6 = map['Table']['weekDay4']['coupleEven6'];
    List<dynamic> day4Even7 = map['Table']['weekDay4']['coupleEven7'];
    List<dynamic> day4Odd1 = map['Table']['weekDay4']['coupleOdd1'];
    List<dynamic> day4Odd2 = map['Table']['weekDay4']['coupleOdd2'];
    List<dynamic> day4Odd3 = map['Table']['weekDay4']['coupleOdd3'];
    List<dynamic> day4Odd4 = map['Table']['weekDay4']['coupleOdd4'];
    List<dynamic> day4Odd5 = map['Table']['weekDay4']['coupleOdd5'];
    List<dynamic> day4Odd6 = map['Table']['weekDay4']['coupleOdd6'];
    List<dynamic> day4Odd7 = map['Table']['weekDay4']['coupleOdd7'];

    List<dynamic> day5All1 = map['Table']['weekDay5']['coupleAll1'];
    List<dynamic> day5All2 = map['Table']['weekDay5']['coupleAll2'];
    List<dynamic> day5All3 = map['Table']['weekDay5']['coupleAll3'];
    List<dynamic> day5All4 = map['Table']['weekDay5']['coupleAll4'];
    List<dynamic> day5All5 = map['Table']['weekDay5']['coupleAll5'];
    List<dynamic> day5All6 = map['Table']['weekDay5']['coupleAll6'];
    List<dynamic> day5All7 = map['Table']['weekDay5']['coupleAll7'];
    List<dynamic> day5Even1 = map['Table']['weekDay5']['coupleEven1'];
    List<dynamic> day5Even2 = map['Table']['weekDay5']['coupleEven2'];
    List<dynamic> day5Even3 = map['Table']['weekDay5']['coupleEven3'];
    List<dynamic> day5Even4 = map['Table']['weekDay5']['coupleEven4'];
    List<dynamic> day5Even5 = map['Table']['weekDay5']['coupleEven5'];
    List<dynamic> day5Even6 = map['Table']['weekDay5']['coupleEven6'];
    List<dynamic> day5Even7 = map['Table']['weekDay5']['coupleEven7'];
    List<dynamic> day5Odd1 = map['Table']['weekDay5']['coupleOdd1'];
    List<dynamic> day5Odd2 = map['Table']['weekDay5']['coupleOdd2'];
    List<dynamic> day5Odd3 = map['Table']['weekDay5']['coupleOdd3'];
    List<dynamic> day5Odd4 = map['Table']['weekDay5']['coupleOdd4'];
    List<dynamic> day5Odd5 = map['Table']['weekDay5']['coupleOdd5'];
    List<dynamic> day5Odd6 = map['Table']['weekDay5']['coupleOdd6'];
    List<dynamic> day5Odd7 = map['Table']['weekDay5']['coupleOdd7'];

    List<dynamic> day6All1 = map['Table']['weekDay6']['coupleAll1'];
    List<dynamic> day6All2 = map['Table']['weekDay6']['coupleAll2'];
    List<dynamic> day6All3 = map['Table']['weekDay6']['coupleAll3'];
    List<dynamic> day6All4 = map['Table']['weekDay6']['coupleAll4'];
    List<dynamic> day6All5 = map['Table']['weekDay6']['coupleAll5'];
    List<dynamic> day6All6 = map['Table']['weekDay6']['coupleAll6'];
    List<dynamic> day6All7 = map['Table']['weekDay6']['coupleAll7'];
    List<dynamic> day6Even1 = map['Table']['weekDay6']['coupleEven1'];
    List<dynamic> day6Even2 = map['Table']['weekDay6']['coupleEven2'];
    List<dynamic> day6Even3 = map['Table']['weekDay6']['coupleEven3'];
    List<dynamic> day6Even4 = map['Table']['weekDay6']['coupleEven4'];
    List<dynamic> day6Even5 = map['Table']['weekDay6']['coupleEven5'];
    List<dynamic> day6Even6 = map['Table']['weekDay6']['coupleEven6'];
    List<dynamic> day6Even7 = map['Table']['weekDay6']['coupleEven7'];
    List<dynamic> day6Odd1 = map['Table']['weekDay6']['coupleOdd1'];
    List<dynamic> day6Odd2 = map['Table']['weekDay6']['coupleOdd2'];
    List<dynamic> day6Odd3 = map['Table']['weekDay6']['coupleOdd3'];
    List<dynamic> day6Odd4 = map['Table']['weekDay6']['coupleOdd4'];
    List<dynamic> day6Odd5 = map['Table']['weekDay6']['coupleOdd5'];
    List<dynamic> day6Odd6 = map['Table']['weekDay6']['coupleOdd6'];
    List<dynamic> day6Odd7 = map['Table']['weekDay6']['coupleOdd7'];

    modelDay1All1 = parseCouple(day1All1);
    modelDay1All2 = parseCouple(day1All2);
    modelDay1All3 = parseCouple(day1All3);
    modelDay1All4 = parseCouple(day1All4);
    modelDay1All5 = parseCouple(day1All5);
    modelDay1All6 = parseCouple(day1All6);
    modelDay1All7 = parseCouple(day1All7);
    modelDay1Even1 = parseCouple(day1Even1);
    modelDay1Even2 = parseCouple(day1Even2);
    modelDay1Even3 = parseCouple(day1Even3);
    modelDay1Even4 = parseCouple(day1Even4);
    modelDay1Even5 = parseCouple(day1Even5);
    modelDay1Even6 = parseCouple(day1Even6);
    modelDay1Even7 = parseCouple(day1Even7);
    modelDay1Odd1 = parseCouple(day1Odd1);
    modelDay1Odd2 = parseCouple(day1Odd2);
    modelDay1Odd3 = parseCouple(day1Odd3);
    modelDay1Odd4 = parseCouple(day1Odd4);
    modelDay1Odd5 = parseCouple(day1Odd5);
    modelDay1Odd6 = parseCouple(day1Odd6);
    modelDay1Odd7 = parseCouple(day1Odd7);

    day1All = [
      modelDay1All1,
      modelDay1All2,
      modelDay1All3,
      modelDay1All4,
      modelDay1All5,
      modelDay1All6,
      modelDay1All7
    ];
    day1Even = [
      modelDay1Even1,
      modelDay1Even2,
      modelDay1Even3,
      modelDay1Even4,
      modelDay1Even5,
      modelDay1Even6,
      modelDay1Even7
    ];
    day1Odd = [
      modelDay1Odd1,
      modelDay1Odd2,
      modelDay1Odd3,
      modelDay1Odd4,
      modelDay1Odd5,
      modelDay1Odd6,
      modelDay1Odd7
    ];

    modelDay2All1 = parseCouple(day2All1);
    modelDay2All2 = parseCouple(day2All2);
    modelDay2All3 = parseCouple(day2All3);
    modelDay2All4 = parseCouple(day2All4);
    modelDay2All5 = parseCouple(day2All5);
    modelDay2All6 = parseCouple(day2All6);
    modelDay2All7 = parseCouple(day2All7);
    modelDay2Even1 = parseCouple(day2Even1);
    modelDay2Even2 = parseCouple(day2Even2);
    modelDay2Even3 = parseCouple(day2Even3);
    modelDay2Even4 = parseCouple(day2Even4);
    modelDay2Even5 = parseCouple(day2Even5);
    modelDay2Even6 = parseCouple(day2Even6);
    modelDay2Even7 = parseCouple(day2Even7);
    modelDay2Odd1 = parseCouple(day2Odd1);
    modelDay2Odd2 = parseCouple(day2Odd2);
    modelDay2Odd3 = parseCouple(day2Odd3);
    modelDay2Odd4 = parseCouple(day2Odd4);
    modelDay2Odd5 = parseCouple(day2Odd5);
    modelDay2Odd6 = parseCouple(day2Odd6);
    modelDay2Odd7 = parseCouple(day2Odd7);

    day2All = [
      modelDay2All1,
      modelDay2All2,
      modelDay2All3,
      modelDay2All4,
      modelDay2All5,
      modelDay2All6,
      modelDay2All7
    ];
    day2Even = [
      modelDay2Even1,
      modelDay2Even2,
      modelDay2Even3,
      modelDay2Even4,
      modelDay2Even5,
      modelDay2Even6,
      modelDay2Even7
    ];
    day2Odd = [
      modelDay2Odd1,
      modelDay2Odd2,
      modelDay2Odd3,
      modelDay2Odd4,
      modelDay2Odd5,
      modelDay2Odd6,
      modelDay2Odd7
    ];

    modelDay3All1 = parseCouple(day3All1);
    modelDay3All2 = parseCouple(day3All2);
    modelDay3All3 = parseCouple(day3All3);
    modelDay3All4 = parseCouple(day3All4);
    modelDay3All5 = parseCouple(day3All5);
    modelDay3All6 = parseCouple(day3All6);
    modelDay3All7 = parseCouple(day3All7);
    modelDay3Even1 = parseCouple(day3Even1);
    modelDay3Even2 = parseCouple(day3Even2);
    modelDay3Even3 = parseCouple(day3Even3);
    modelDay3Even4 = parseCouple(day3Even4);
    modelDay3Even5 = parseCouple(day3Even5);
    modelDay3Even6 = parseCouple(day3Even6);
    modelDay3Even7 = parseCouple(day3Even7);
    modelDay3Odd1 = parseCouple(day3Odd1);
    modelDay3Odd2 = parseCouple(day3Odd2);
    modelDay3Odd3 = parseCouple(day3Odd3);
    modelDay3Odd4 = parseCouple(day3Odd4);
    modelDay3Odd5 = parseCouple(day3Odd5);
    modelDay3Odd6 = parseCouple(day3Odd6);
    modelDay3Odd7 = parseCouple(day3Odd7);

    day3All = [
      modelDay3All1,
      modelDay3All2,
      modelDay3All3,
      modelDay3All4,
      modelDay3All5,
      modelDay3All6,
      modelDay3All7
    ];
    day3Even = [
      modelDay3Even1,
      modelDay3Even2,
      modelDay3Even3,
      modelDay3Even4,
      modelDay3Even5,
      modelDay3Even6,
      modelDay3Even7
    ];
    day3Odd = [
      modelDay3Odd1,
      modelDay3Odd2,
      modelDay3Odd3,
      modelDay3Odd4,
      modelDay3Odd5,
      modelDay3Odd6,
      modelDay3Odd7
    ];

    modelDay4All1 = parseCouple(day4All1);
    modelDay4All2 = parseCouple(day4All2);
    modelDay4All3 = parseCouple(day4All3);
    modelDay4All4 = parseCouple(day4All4);
    modelDay4All5 = parseCouple(day4All5);
    modelDay4All6 = parseCouple(day4All6);
    modelDay4All7 = parseCouple(day4All7);
    modelDay4Even1 = parseCouple(day4Even1);
    modelDay4Even2 = parseCouple(day4Even2);
    modelDay4Even3 = parseCouple(day4Even3);
    modelDay4Even4 = parseCouple(day4Even4);
    modelDay4Even5 = parseCouple(day4Even5);
    modelDay4Even6 = parseCouple(day4Even6);
    modelDay4Even7 = parseCouple(day4Even7);
    modelDay4Odd1 = parseCouple(day4Odd1);
    modelDay4Odd2 = parseCouple(day4Odd2);
    modelDay4Odd3 = parseCouple(day4Odd3);
    modelDay4Odd4 = parseCouple(day4Odd4);
    modelDay4Odd5 = parseCouple(day4Odd5);
    modelDay4Odd6 = parseCouple(day4Odd6);
    modelDay4Odd7 = parseCouple(day4Odd7);

    day4All = [
      modelDay4All1,
      modelDay4All2,
      modelDay4All3,
      modelDay4All4,
      modelDay4All5,
      modelDay4All6,
      modelDay4All7
    ];
    day4Even = [
      modelDay4Even1,
      modelDay4Even2,
      modelDay4Even3,
      modelDay4Even4,
      modelDay4Even5,
      modelDay4Even6,
      modelDay4Even7
    ];
    day4Odd = [
      modelDay4Odd1,
      modelDay4Odd2,
      modelDay4Odd3,
      modelDay4Odd4,
      modelDay4Odd5,
      modelDay4Odd6,
      modelDay4Odd7
    ];

    modelDay5All1 = parseCouple(day5All1);
    modelDay5All2 = parseCouple(day5All2);
    modelDay5All3 = parseCouple(day5All3);
    modelDay5All4 = parseCouple(day5All4);
    modelDay5All5 = parseCouple(day5All5);
    modelDay5All6 = parseCouple(day5All6);
    modelDay5All7 = parseCouple(day5All7);
    modelDay5Even1 = parseCouple(day5Even1);
    modelDay5Even2 = parseCouple(day5Even2);
    modelDay5Even3 = parseCouple(day5Even3);
    modelDay5Even4 = parseCouple(day5Even4);
    modelDay5Even5 = parseCouple(day5Even5);
    modelDay5Even6 = parseCouple(day5Even6);
    modelDay5Even7 = parseCouple(day5Even7);
    modelDay5Odd1 = parseCouple(day5Odd1);
    modelDay5Odd2 = parseCouple(day5Odd2);
    modelDay5Odd3 = parseCouple(day5Odd3);
    modelDay5Odd4 = parseCouple(day5Odd4);
    modelDay5Odd5 = parseCouple(day5Odd5);
    modelDay5Odd6 = parseCouple(day5Odd6);
    modelDay5Odd7 = parseCouple(day5Odd7);

    day5All = [
      modelDay5All1,
      modelDay5All2,
      modelDay5All3,
      modelDay5All4,
      modelDay5All5,
      modelDay5All6,
      modelDay5All7
    ];
    day5Even = [
      modelDay5Even1,
      modelDay5Even2,
      modelDay5Even3,
      modelDay5Even4,
      modelDay5Even5,
      modelDay5Even6,
      modelDay5Even7
    ];
    day5Odd = [
      modelDay5Odd1,
      modelDay5Odd2,
      modelDay5Odd3,
      modelDay5Odd4,
      modelDay5Odd5,
      modelDay5Odd6,
      modelDay5Odd7
    ];

    modelDay6All1 = parseCouple(day6All1);
    modelDay6All2 = parseCouple(day6All2);
    modelDay6All3 = parseCouple(day6All3);
    modelDay6All4 = parseCouple(day6All4);
    modelDay6All5 = parseCouple(day6All5);
    modelDay6All6 = parseCouple(day6All6);
    modelDay6All7 = parseCouple(day6All7);
    modelDay6Even1 = parseCouple(day6Even1);
    modelDay6Even2 = parseCouple(day6Even2);
    modelDay6Even3 = parseCouple(day6Even3);
    modelDay6Even4 = parseCouple(day6Even4);
    modelDay6Even5 = parseCouple(day6Even5);
    modelDay6Even6 = parseCouple(day6Even6);
    modelDay6Even7 = parseCouple(day6Even7);
    modelDay6Odd1 = parseCouple(day6Odd1);
    modelDay6Odd2 = parseCouple(day6Odd2);
    modelDay6Odd3 = parseCouple(day6Odd3);
    modelDay6Odd4 = parseCouple(day6Odd4);
    modelDay6Odd5 = parseCouple(day6Odd5);
    modelDay6Odd6 = parseCouple(day6Odd6);
    modelDay6Odd7 = parseCouple(day6Odd7);

    day6All = [
      modelDay6All1,
      modelDay6All2,
      modelDay6All3,
      modelDay6All4,
      modelDay6All5,
      modelDay6All6,
      modelDay6All7
    ];
    day6Even = [
      modelDay6Even1,
      modelDay6Even2,
      modelDay6Even3,
      modelDay6Even4,
      modelDay6Even5,
      modelDay6Even6,
      modelDay6Even7
    ];
    day6Odd = [
      modelDay6Odd1,
      modelDay6Odd2,
      modelDay6Odd3,
      modelDay6Odd4,
      modelDay6Odd5,
      modelDay6Odd6,
      modelDay6Odd7
    ];
    circle = false;
    notifyListeners();
    tableOn();

    //coupleModel = parseCouple(day1);

    //print(modelDay3All1[0].discName);
    //print(day1[0].coupleAll1);
    notifyListeners();
  }

  void choiceSchedule() async {
    currentTable = false;
    await getSchedule();
    notifyListeners();
  }
}
