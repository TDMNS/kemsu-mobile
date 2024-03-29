import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../Configurations/config.dart';
import '../info/info_model.dart';
import 'dart:convert';

class InfoOUProViewModel extends BaseViewModel {
  InfoOUProViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<CourseInfoOUPro> course = [];

  List<ReportInfoOUPro> report = [];

  List<TaskListInfoOUPro> task = [];

  int selectedIndex = 2;
  bool isChecked = false;

  List<CourseInfoOUPro> parseCourseList(List response) {
    return response.map<CourseInfoOUPro>((json) => CourseInfoOUPro.fromJson(json)).toList();
  }

  List<ReportInfoOUPro> parseReportList(List response) {
    return response.map<ReportInfoOUPro>((json) => ReportInfoOUPro.fromJson(json)).toList();
  }

  Future onReady() async {
    getDiscs(0);
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('InfoOUPro event');
  }

  getDiscs(allFlag) async {
    String? token = await storage.read(key: "tokenKey");
    http.Response response;
    if (allFlag == 1) {
      response = await http.get(
        Uri.parse('${Config.studCourseList}?allCourseFlag=1'),
        headers: {
          "x-access-token": token!,
        },
      );
    } else {
      response = await http.get(
        Uri.parse('${Config.studCourseList}?allCourseFlag=0'),
        headers: {
          "x-access-token": token!,
        },
      );
    }

    course = parseCourseList(json.decode(response.body)['studentCourseList']);

    notifyListeners();
  }

  getDiscReports(courseId) async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(
      Uri.parse('${Config.studRepList}/$courseId'),
      headers: {
        "x-access-token": token!,
      },
    );

    report = parseReportList(json.decode(response.body)['studentReportList']);

    notifyListeners();
  }
}
