import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import 'check_list_model.dart';
import 'dart:convert';

class CheckListViewModel extends BaseViewModel {
  CheckListViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<CheckList> checkList = [];

  int selectedIndex = 2;

  List<CheckList> parseCheckList(List response) {
    return response.map<CheckList>((json) => CheckList.fromJson(json)).toList();
  }

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(
      Uri.parse(Config.studCheckList),
      headers: {
        "x-access-token": token!,
      },
    );
    checkList = parseCheckList(json.decode(response.body)['checkList']);
    print("Result: ${response.body}");
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Workaround event');
  }
}
