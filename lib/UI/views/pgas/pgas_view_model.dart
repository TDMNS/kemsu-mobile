import 'dart:async';
import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/auth/auth_view.dart';
import 'package:kemsu_app/UI/views/auth/new_auth/auth_screen.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_detail/pgas_detail_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../Configurations/config.dart';
import 'short_pgas_request_model.dart';
import 'new_pgas_request/new_pgas_request_screen.dart';

class PgasViewModel extends BaseViewModel {
  PgasViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<ShortPgasRequestModel> pgasList = [];
  bool circle = true;

  Future onReady(context) async {
    await fetchPgasRequests(context);
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Pgas event');
  }

  void refreshData(context) async {
    await fetchPgasRequests(context);
  }

  FutureOr onGoBack(context) {
    refreshData(context);
  }

  goToNewPgasRequest(context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewPgasRequestScreen()))
        .then((value) => onGoBack(context));
  }

  goToPgasDetail(context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PgasDetailScreen()))
        .then((value) => onGoBack(context));
  }

  fetchPgasRequests(context) async {
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    var response = await http.post(
        Uri.parse(Config.pgasGetRequestList),
        headers: header);
    if (response.statusCode == 200 || response.statusCode == 201) {
      pgasList = parsePgasRequests(json.decode(response.body)["result"]);
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (Route<dynamic> route) => false);
      await storage.delete(key: "tokenKey");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Сессия ЭИОС истекла. Пожалуйста, авторизуйтесь повторно")));
    }
  }

  List<ShortPgasRequestModel> parsePgasRequests(List response) {
    return response
        .map<ShortPgasRequestModel>(
            (json) => ShortPgasRequestModel.fromJson(json))
        .toList();
  }
}
