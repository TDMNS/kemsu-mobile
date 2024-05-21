import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_lib_model.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_pay_model.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_interceptor/dio_client.dart';
import 'models/debts_academy_model.dart';

class EnumDebts {
  static String get academyDebtsTitle => "Академическая задолженность";
  static String get libraryDebtsTitle => "Задолженность по книгам в библиотеке";
  static String get payDebtsTitle => "Задолженность за обучение";
}

class DebtsViewModel extends BaseViewModel {
  DebtsViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();

  List<AcademyDebts> academyDebts = [];
  List<LibraryDebts> libraryDebts = [];
  List<PayDebts> payDebts = [];

  int selectedIndex = 2;
  bool circle = true;

  Future onReady() async {
    await getAcademyDebts();
    await getLibraryDebts();
    await getPayDebts();
    appMetricTest();
    circle = false;
  }

  Future<void> getAcademyDebts() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.studDebt,
      options: Options(headers: {'x-access-token': token!}),
    );

    academyDebts = parseAcademyDebtsList(response.data['studyDebtList']);
    notifyListeners();
  }

  List<AcademyDebts> parseAcademyDebtsList(List response) {
    return response.map<AcademyDebts>((json) => AcademyDebts.fromJson(json)).toList();
  }

  Future<void> getLibraryDebts() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.libraryDebt,
      options: Options(headers: {'x-access-token': token!}),
    );

    libraryDebts = parseLibraryDebtsList(response.data['literatureDebtList']);
    notifyListeners();
  }

  List<LibraryDebts> parseLibraryDebtsList(List response) {
    return response.map<LibraryDebts>((json) => LibraryDebts.fromJson(json)).toList();
  }

  Future<void> updateDebts() async {
    String? token = await storage.read(key: "tokenKey");
    await dio.get(
      Config.academicDebtUpdate,
      options: Options(headers: {'x-access-token': token!}),
    );
    await dio.get(
      Config.libraryDebtUpdate,
      options: Options(headers: {'x-access-token': token!}),
    );
  }

  Future<void> getPayDebts() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.studMoneyDebt,
      options: Options(headers: {'x-access-token': '$token'}),
    );

    final moneyDebt = response.data["debtInfo"];
    if (moneyDebt["DEBT_AMOUNT"] != null && moneyDebt["DEBT_DATE"] != null) {
      payDebts = [PayDebts.fromJson(moneyDebt)];
    }

    notifyListeners();
  }

  List<PayDebts> parsePayDebtsList(List response) {
    return response.map<PayDebts>((json) => PayDebts.fromJson(json)).toList();
  }

  void appMetricTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Debts event');
  }
}
