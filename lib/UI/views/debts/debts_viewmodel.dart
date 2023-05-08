import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_lib_model.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_pay_model.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../Configurations/config.dart';
import 'models/debts_academy_model.dart';
import 'dart:convert';

class EnumDebts {
  static String get academyDebtsTitle => "Академическая задолженность";
  static String get libraryDebtsTitle => "Задолженность по книгам в библиотеке";
  static String get payDebtsTitle => "Задолженность за платные услуги";
}

class DebtsViewModel extends BaseViewModel {
  DebtsViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<AcademyDebts> academyDebts = [];
  List<LibraryDebts> libraryDebts = [];
  List<PayDebts> payDebts = [];

  int selectedIndex = 2;

  Future onReady() async {
    getAcademyDebts();
    getLibraryDebts();
    getPayDebts();
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

    academyDebts = parseAcademyDebtsList(json.decode(response.body)['studyDebtList']);

    notifyListeners();
  }

  List<AcademyDebts> parseAcademyDebtsList(List response) {
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

    libraryDebts = parseLibraryDebtsList(json.decode(response.body)['literatureDebtList']);
    notifyListeners();
  }

  List<LibraryDebts> parseLibraryDebtsList(List response) {
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

  getPayDebts() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(
      Uri.parse(Config.studMoneyDebt),
      headers: {
        "x-access-token": token!,
      },
    );

    final moneyDebt = json.decode(response.body)["debtInfo"];
    if (moneyDebt["DEBT_AMOUNT"] != null && moneyDebt["DEBT_DATE"] != null) {
      payDebts = parsePayDebtsList(json.decode(response.body)["debtInfo"]);
    }

    notifyListeners();
  }

  List<PayDebts> parsePayDebtsList(List response) {
    return response
        .map<PayDebts>((json) => PayDebts.fromJson(json))
        .toList();
  }

  void appMetricTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Debts event');
  }
}
