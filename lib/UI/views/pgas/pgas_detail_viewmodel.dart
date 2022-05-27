import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/pgas/model/user_achieve.dart';
import 'package:stacked/stacked.dart';

import 'pgas_request_info_screen.dart';

class PgasDetailViewModel extends BaseViewModel {
  PgasDetailViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();

  List<UserAchieveModel> userAchievesList = [];

  Future onReady() async {
    await fetchUserAchieves();
  }

  void refreshData(context) async {
    await fetchUserAchieves();
  }

  FutureOr onGoBack(context) {
    refreshData(context);
  }

  fetchUserAchieves() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? requestId = await storage.read(key: 'pgas_id');
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };

    Map<String, dynamic> body = {
      "requestId": "$requestId"
    };

    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getUserActivityList"), headers: header, body: body);

    userAchievesList = parseUserAchieves(json.decode(response.body)["result"]);
    notifyListeners();
  }

  deleteBtnAction(context, int? userActivityId) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");

    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };

    Map<String, dynamic> body = {
      "userActivityId": userActivityId.toString()
    };

    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/deleteUserActivity"), headers: header, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.body)["message"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.body)["message"])));
      print(response.body);
    }
  }

  List<UserAchieveModel> parseUserAchieves(List response) {
    return response
        .map<UserAchieveModel>((json) => UserAchieveModel.fromJson(json))
        .toList();
  }

  goToPgasRequestInfoScreen(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PgasRequestInfoScreen()));
  }

  goToPgasRequestList(context) {
    Navigator.pop(context);
  }
}