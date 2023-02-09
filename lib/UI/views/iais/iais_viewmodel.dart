import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../iais/iais_model.dart';
import 'dart:convert';

class IaisViewModel extends BaseViewModel {
  IaisViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<CourseIais> Course = [];

  List<ReportIais> Report = [];

  List<TaskListIais> Task = [];

  int selectedIndex = 2;
  bool isChecked = false;

  List<CourseIais> parseCourseList(List response) {
    return response
        .map<CourseIais>((json) => CourseIais.fromJson(json))
        .toList();
  }

  List<ReportIais> parseReportList(List response) {
    return response
        .map<ReportIais>((json) => ReportIais.fromJson(json))
        .toList();
  }

  Future onReady() async {
    getDiscs(0);
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Iais event');
  }

  getDiscs(allFlag) async {
    String? token = await storage.read(key: "tokenKey");
    var response;
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

    Course = parseCourseList(json.decode(response.body)['studentCourseList']);

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

    Report = parseReportList(json.decode(response.body)['studentReportList']);

    notifyListeners();
  }
}
