import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/schedule/schedule2.0_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import 'package:html/parser.dart' as parser;

class NewScheduleViewModel extends BaseViewModel {
  NewScheduleViewModel(BuildContext context);

  static const storage = FlutterSecureStorage();
  bool circle = true;
  bool tableView = false;
  int indexDay = DateTime.now().weekday;
  bool currentTable = true;
  bool weekType = true;
  int? groupId;
  int? currentSemester;
  int? currentWeek;
  FinalTable? scheduleTable;
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
    print(indexDay);
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
    var getScheduleTable = await http.get(Uri.parse(
        '${Config.scheduleTable}?groupId=$groupId&semesterWeekId=$currentWeek'));
    var mainTable = getScheduleTable.body;
    final jsonResponse = json.decode(mainTable)['result']['Table'];
    final jsonResponseCoupleList =
        json.decode(mainTable)['result']['CoupleList'];
    scheduleTable = FinalTable.fromJson(jsonResponse);
    circle = false;
    notifyListeners();
  }
}
