import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/auth/auth_view.dart';
import 'package:kemsu_app/UI/views/bug_report/report.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class BugReportViewModel extends BaseViewModel {
  BugReportViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool circle = true;
  List<ReportModel> reportList = [];
  TextEditingController errorMsgController = TextEditingController();

  Future onReady(context) async {
    await fetchReports(context);
    circle = false;
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('BugReport event');
  }

  sendAction(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    if (errorMsgController.text.isNotEmpty) {
      notifyListeners();
      Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};

      Map<String, dynamic> body = {
        "message": errorMsgController.text,
      };

      var response = await http.post(
          Uri.parse("https://api-next.kemsu.ru/api/bugreport/main/addReport"),
          headers: header,
          body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchReports(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ваше обращение успешно отправлено.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(json.decode(response.body)["message"])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Заполните все поля обращения!")));
    }

    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Send bugreport event');
  }

  fetchReports(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};
    var response = await http.get(
        Uri.parse("https://api-next.kemsu.ru/api/bugreport/main/reportList"),
        headers: header);
    if (response.statusCode == 200 || response.statusCode == 201) {
      reportList = parseReports(json.decode(response.body)["result"]);
      notifyListeners();
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthView()),
          (Route<dynamic> route) => false);
      await storage.delete(key: "tokenKey");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Сессия ЭИОС истекла. Пожалуйста, авторизуйтесь повторно")));
    }
  }

  List<ReportModel> parseReports(List response) {
    return response
        .map<ReportModel>((json) => ReportModel.fromJson(json))
        .toList();
  }
}
