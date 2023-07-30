import 'dart:async';
import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_detail/user_achieve_model.dart';
import 'package:stacked/stacked.dart';

import '../../../../Configurations/config.dart';
import '../pgas_request_info/pgas_request_info_screen.dart';

class PgasDetailViewModel extends BaseViewModel {
  PgasDetailViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();

  List<UserAchieveModel> userAchievesList = [];

  Future onReady() async {
    await fetchUserAchieves();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Pgas detail event');
  }

  void refreshData(context) async {
    await fetchUserAchieves();
  }

  FutureOr onGoBack(context) {
    refreshData(context);
  }

  fetchUserAchieves() async {
    String? accessToken = await storage.read(key: "tokenKey");
    String? requestId = await storage.read(key: 'pgas_id');
    Map<String, String> header = {"X-Access-Token": "$accessToken"};

    Map<String, dynamic> body = {"requestId": "$requestId"};

    var response = await http.post(
        Uri.parse(Config.pgasGetUserActivityList),
        headers: header,
        body: body);

    userAchievesList = parseUserAchieves(json.decode(response.body)["result"]);
    notifyListeners();
  }

  deleteBtnAction(context, UserAchieveModel achieveModel) async {
    String? accessToken = await storage.read(key: "tokenKey");

    Map<String, String> header = {"X-Access-Token": accessToken.toString()};

    Map<String, dynamic> body = {
      "userActivityId": achieveModel.userActivityId.toString()
    };

    if (achieveModel.activityFile != null) {
      await deletePgasFile(context, achieveModel.activityFile);
    }

    var response = await http.post(
        Uri.parse(Config.pgasDeleteUserActivity),
        headers: header,
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      userAchievesList.remove(achieveModel);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    }
  }

  deletePgasFile(context, String? fileName) async {
    String? accessToken = await storage.read(key: "tokenKey");

    Map<String, String> header = {"X-Access-Token": "$accessToken"};

    var _ = await http.delete(
        Uri.parse(
            "${Config.pgasStorage}/${fileName.toString()}"),
        headers: header);
  }

  List<UserAchieveModel> parseUserAchieves(List response) {
    return response
        .map<UserAchieveModel>((json) => UserAchieveModel.fromJson(json))
        .toList();
  }

  goToPgasRequestInfoScreen(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PgasRequestInfoScreen()));
  }

  goToPgasRequestList(context) {
    Navigator.pop(context);
  }
}
