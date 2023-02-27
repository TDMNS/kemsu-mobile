import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_lib_model.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import 'models/debts_model.dart';
import 'dart:convert';

class EnumDebts {
  static String get academicDebt => "Академическая задолженность";
  static String get libraryDebt => "Задолженность по книгам в библиотеке";
  static String get payDebt => "Задолженность за платные услуги";
}

class DebtsViewModel extends BaseViewModel {
  DebtsViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<AcademyDebts> debtsCourse = [];
  List<LibraryDebts> libraryDebts = [];

  int selectedIndex = 2;

  String? defaultDebt;
  List<String> debtsType = [EnumDebts.academicDebt, EnumDebts.libraryDebt, EnumDebts.payDebt];

  Future onReady() async {
    getAcademyDebts();
    getLibraryDebts();
    appMetricTest();
  }

  getAcademyDebts() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(
      Uri.parse(Config.studDebt),
      headers: {
        "x-access-token": token!,
      },
    );

    debtsCourse = parseCourseList(json.decode(response.body)['studyDebtList']);

    notifyListeners();
  }

  List<AcademyDebts> parseCourseList(List response) {
    return response
        .map<AcademyDebts>((json) => AcademyDebts.fromJson(json))
        .toList();
  }

  getLibraryDebts() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(
      Uri.parse(Config.libraryDebt),
      headers: {
        "x-access-token": token!,
      },
    );

    libraryDebts = parseLibraryList(json.decode(response.body)['literatureDebtList']);
    notifyListeners();
  }

  List<LibraryDebts> parseLibraryList(List response) {
    return response
        .map<LibraryDebts>((json) => LibraryDebts.fromJson(json))
        .toList();
  }

  updateDebts() async {
    String? token = await storage.read(key: "tokenKey");
    await http.get(
      Uri.parse(Config.academicDebtUpdate),
      headers: {
        "x-access-token": token!,
      },
    );
    await http.get(
      Uri.parse(Config.libraryDebtUpdate),
      headers: {
        "x-access-token": token,
      },
    );
  }

  changeCard(value) async {
    defaultDebt = value;
    notifyListeners();
  }

  void appMetricTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Debts event');
  }
}
