import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../debts/debts_model.dart';
import 'dart:convert';

class DebtsViewModel extends BaseViewModel {
  DebtsViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<AcademyDebts> debtsCourse = [];

  int selectedIndex = 2;

  List<AcademyDebts> parseCourseList(List response) {
    return response
        .map<AcademyDebts>((json) => AcademyDebts.fromJson(json))
        .toList();
  }

  Future onReady() async {
    getAcademyDebts();
  }

  getAcademyDebts() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse(Config.studDebt), headers: {"x-access-token": token!,},);

    debtsCourse = parseCourseList(json.decode(response.body)['studyDebtList']);

    notifyListeners();
  }
}