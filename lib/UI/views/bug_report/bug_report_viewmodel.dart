import 'dart:convert';

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
    notifyListeners();
  }

  sendAction(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    if (errorMsgController.text.isNotEmpty) {
      notifyListeners();
      Map<String, String> header = {
        "X-Access-Token": "$eiosAccessToken"
      };

      Map<String, dynamic> body = {
        "message": errorMsgController.text,
      };

      var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/bugreport/main/addReport"), headers: header, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchReports(context);
        Navigator.pop(context);
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ваше обращение успешно отправлено.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.body)["message"])));
        print(response.body);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Заполните все поля обращения!")));
    }
  }

  fetchReports(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.get(Uri.parse("https://api-next.kemsu.ru/api/bugreport/main/reportList"), headers: header);
    if (response.statusCode == 200 || response.statusCode == 201) {
      reportList = parseReports(json.decode(response.body)["result"]);
      print(response.body);
      notifyListeners();
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthView()), (Route<dynamic> route) => false);
      await storage.delete(key: "tokenKey");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Сессия ЭИОС истекла. Пожалуйста, авторизуйтесь повторно")));
    }
  }

  List<ReportModel> parseReports(List response) {
    return response
        .map<ReportModel>((json) => ReportModel.fromJson(json))
        .toList();
  }
}