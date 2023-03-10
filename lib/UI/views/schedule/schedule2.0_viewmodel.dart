import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/schedule2.0_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';

class NewScheduleViewModel extends BaseViewModel {
  NewScheduleViewModel(BuildContext context);

  int selectedIndex = 2;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  static const storage = FlutterSecureStorage();
  bool circle = true;
  bool tableView = false;
  int indexDay = DateTime.now().weekday - 1;
  bool currentTable = false;
  bool weekType = true;
  int? groupId;
  int? groupIdChoice;
  int? currentSemester;
  int? currentWeek;
  FinalTable? scheduleTable;
  FinalTableString? scheduleTableString;
  List<WeekDayString>? daysList;
  List<String>? coupleAllList;
  List<String>? coupleEvenList;
  List<String>? coupleOddList;
  ScheduleRequest? scheduleSemester;
  FacultyList? scheduleFaculty;
  GroupList? scheduleGroup;
  // List<CoupleData> coupleAllList = [];
  // List<CoupleData> coupleOddList = [];
  // List<CoupleData> coupleEvenList = [];
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
  List<WeekDay> weekDays = [];

  Future onReady() async {
    getScheduleOnRequest();
    getScheduleString();
    getSchedule();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Student schedule event');
  }

  void changeWeek(value) {
    weekType = value;
    notifyListeners();
  }

  void choiceDay(action) {
    if (action == 'next') {
      indexDay++;
      indexDay == 6 ? indexDay = 0 : indexDay == 0;
    } else if (action == 'back') {
      indexDay--;
      indexDay == -1 ? indexDay = 6 : indexDay == 6;
    }

    coupleAllList = [
      daysList![indexDay].coupleAll1!,
      daysList![indexDay].coupleAll2!,
      daysList![indexDay].coupleAll3!,
      daysList![indexDay].coupleAll4!,
      daysList![indexDay].coupleAll5!,
      daysList![indexDay].coupleAll6!,
      daysList![indexDay].coupleAll7!
    ];

    coupleEvenList = [
      daysList![indexDay].coupleEven1!,
      daysList![indexDay].coupleEven2!,
      daysList![indexDay].coupleEven3!,
      daysList![indexDay].coupleEven4!,
      daysList![indexDay].coupleEven5!,
      daysList![indexDay].coupleEven6!,
      daysList![indexDay].coupleEven7!
    ];
    coupleOddList = [
      daysList![indexDay].coupleOdd1!,
      daysList![indexDay].coupleOdd2!,
      daysList![indexDay].coupleOdd3!,
      daysList![indexDay].coupleOdd4!,
      daysList![indexDay].coupleOdd5!,
      daysList![indexDay].coupleOdd6!,
      daysList![indexDay].coupleOdd7!
    ];
    notifyListeners();
  }

  void choiceSchedule() async {
    currentTable = false;
    await getScheduleString();
    notifyListeners();
  }

  tableViewOnOff(data) {
    tableView = data;
    notifyListeners();
  }

  getScheduleString() async {
    circle = true;
    indexDay == 6 ? indexDay = 1 : indexDay == 1;
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();
    var semesterResponse = await dio.get(Config.semesterList);
    var response = await dio.get(Config.currentGroupList, queryParameters: {"accessToken": token});
    groupId = response.data['currentGroupList'][0]['groupId'];
    currentSemester = semesterResponse.data['result'][0]['Id'];
    var weekResponse = await dio.get('${Config.weekList}?semesterId=$currentSemester');
    currentWeek = weekResponse.data['result'][0]['Id'];
    currentTable == true ? groupId = groupIdChoice : groupId = response.data['currentGroupList'][0]['groupId'];
    var getScheduleTable =
        await http.get(Uri.parse('${Config.scheduleTable}?groupId=$groupId&semesterWeekId=$currentWeek'));
    var mainTable = getScheduleTable.body;
    final jsonResponse = json.decode(mainTable)['result']['Table'];
    scheduleTableString = FinalTableString.fromJson(jsonResponse);
    daysList = [
      scheduleTableString!.weekDay1!,
      scheduleTableString!.weekDay2!,
      scheduleTableString!.weekDay3!,
      scheduleTableString!.weekDay4!,
      scheduleTableString!.weekDay5!,
      scheduleTableString!.weekDay6!
    ];

    coupleAllList = [
      daysList![indexDay].coupleAll1!,
      daysList![indexDay].coupleAll2!,
      daysList![indexDay].coupleAll3!,
      daysList![indexDay].coupleAll4!,
      daysList![indexDay].coupleAll5!,
      daysList![indexDay].coupleAll6!,
      daysList![indexDay].coupleAll7!
    ];

    coupleEvenList = [
      daysList![indexDay].coupleEven1!,
      daysList![indexDay].coupleEven2!,
      daysList![indexDay].coupleEven3!,
      daysList![indexDay].coupleEven4!,
      daysList![indexDay].coupleEven5!,
      daysList![indexDay].coupleEven6!,
      daysList![indexDay].coupleEven7!
    ];
    coupleOddList = [
      daysList![indexDay].coupleOdd1!,
      daysList![indexDay].coupleOdd2!,
      daysList![indexDay].coupleOdd3!,
      daysList![indexDay].coupleOdd4!,
      daysList![indexDay].coupleOdd5!,
      daysList![indexDay].coupleOdd6!,
      daysList![indexDay].coupleOdd7!
    ];
    circle = false;
    tableView = true;
    notifyListeners();
  }

  getSchedule() async {
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();
    var semesterResponse = await dio.get(Config.semesterList);
    var response = await dio.get(Config.currentGroupList, queryParameters: {"accessToken": token});
    groupId = response.data['currentGroupList'][0]['groupId'];
    currentSemester = semesterResponse.data['result'][0]['Id'];
    var weekResponse = await dio.get('${Config.weekList}?semesterId=$currentSemester');
    currentWeek = weekResponse.data['result'][0]['Id'];
    currentTable == true ? groupId = groupIdChoice : groupId = response.data['currentGroupList'][0]['groupId'];
    var getScheduleTable =
        await http.get(Uri.parse('${Config.scheduleTable}?groupId=$groupId&semesterWeekId=$currentWeek'));
    var mainTable = getScheduleTable.body;
    final jsonResponse = json.decode(mainTable)['result']['Table'];
    // final jsonResponseCoupleList =
    // json.decode(mainTable)['result']['CoupleList'];
    scheduleTable = FinalTable.fromJson(jsonResponse);

    weekDays = [
      scheduleTable!.weekDay1!,
      scheduleTable!.weekDay2!,
      scheduleTable!.weekDay3!,
      scheduleTable!.weekDay4!,
      scheduleTable!.weekDay5!,
      scheduleTable!.weekDay6!,
    ];

    circle = false;
    tableView = true;
    notifyListeners();
  }

  getScheduleOnRequest() async {
    var response = await http.get(Uri.parse(Config.semesterList));
    scheduleList = parseSchedule(json.decode(response.body)['result']);
    var response3 = await http.get(Uri.parse('${Config.facultyList}?semesterId=${scheduleList[0].id}'));
    facultyList = parseFaculty(json.decode(response3.body)["result"]);
    currentTable = false;
    circle = false;

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
    return response.map<ScheduleRequest>((json) => ScheduleRequest.fromJson(json)).toList();
  }

  List<FacultyList> parseFaculty(List response) {
    return response.map<FacultyList>((json) => FacultyList.fromJson(json)).toList();
  }

  void changeSemester(value) async {
    tableView = false;
    scheduleFaculty = null;
    scheduleGroup = null;
    scheduleSemester = value;
    notifyListeners();
    var response = await http.get(Uri.parse('${Config.facultyList}?semesterId=${scheduleList[0].id}'));
    facultyList = parseFaculty(json.decode(response.body)["result"]);
    notifyListeners();
  }

  void changeFaculty(value) async {
    tableViewOnOff(false);
    scheduleGroup = null;
    scheduleFaculty = value;
    notifyListeners();
    var response = await http
        .get(Uri.parse('${Config.groupList}?facultyId=${scheduleFaculty!.id}&semesterId=${scheduleList[0].id}'));
    groupList = parseGroup(json.decode(response.body)["result"]);
    notifyListeners();
  }

  void changeGroup(value) async {
    scheduleGroup = value;
    tableViewOnOff(false);
    notifyListeners();
    var response = await http.get(Uri.parse('${Config.weekList}?semesterId=${scheduleList[0].id}'));
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
